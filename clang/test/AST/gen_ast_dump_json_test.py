#!/usr/bin/env python

from __future__ import print_function
from collections import OrderedDict
from shutil import copyfile
import argparse
import json
import os
import pprint
import re
import subprocess
import sys
import tempfile


def normalize(dict_var):
    for k, v in dict_var.items():
        if isinstance(v, OrderedDict):
            normalize(v)
        elif isinstance(v, list):
            for e in v:
                if isinstance(e, OrderedDict):
                    normalize(e)
        elif type(v) is unicode:
            st = v.encode('utf-8')
            if v != "0x0" and re.match(r"0x[0-9A-Fa-f]+", v):
                dict_var[k] = u'0x{{.*}}'
            elif os.path.isfile(v):
                dict_var[k] = u'{{.*}}'
            else:
                splits = (v.split(u' '))
                out_splits = []
                for split in splits:
                    inner_splits = split.rsplit(u':',2)
                    if os.path.isfile(inner_splits[0]):
                        out_splits.append(
                            u'{{.*}}:%s:%s'
                            %(inner_splits[1],
                              inner_splits[2]))
                        continue
                    out_splits.append(split)

                dict_var[k] = ' '.join(out_splits)

def filter_json(dict_var, filters, out):
    for k, v in dict_var.items():
        if type(v) is unicode:
            st = v.encode('utf-8')
            if st in filters:
                out.append(dict_var)
                break
        elif isinstance(v, OrderedDict):
            filter_json(v, filters, out)
        elif isinstance(v, list):
            for e in v:
                if isinstance(e, OrderedDict):
                    filter_json(e, filters, out)
                
def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--clang", help="The clang binary (could be a relative or absolute path)",
                        action="store", required=True)
    parser.add_argument("--source", help="the source file. Command used to generate the json will be of the format <clang> -cc1 -ast-dump=json <opts> <source>",
                        action="store", required=True)
    parser.add_argument("--filters", help="comma separated list of AST filters. Ex: --filters=TypedefDecl,BuiltinType",
                        action="store", default='')
    update_or_generate_group = parser.add_mutually_exclusive_group()
    update_or_generate_group.add_argument("--update", help="Update the file in-place", action="store_true")
    update_or_generate_group.add_argument("--opts", help="other options",
                                          action="store", default='', type=str)
    parser.add_argument("--update-manual", help="When using --update, also update files that do not have the "
                                                "autogenerated disclaimer", action="store_true")
    args = parser.parse_args()

    if not args.source:
        print("Specify the source file to give to clang.")
        return -1

    clang_binary = os.path.abspath(args.clang)
    if not os.path.isfile(clang_binary):
        print("clang binary specified not present.")
        return -1

    note_firstline = "// NOTE: CHECK lines have been autogenerated by " \
                     "gen_ast_dump_json_test.py"
    filters_line_prefix = "// using --filters="
    note = note_firstline

    cmd = [clang_binary, "-cc1"]
    if args.update:
        # When updating the first line of the test must be a RUN: line
        with open(args.source, "r") as srcf:
            first_line = srcf.readline()
            found_autogenerated_line = False
            filters_line = None
            for i, line in enumerate(srcf.readlines()):
                if found_autogenerated_line:
                    # print("Filters line: '", line.rstrip(), "'", sep="")
                    if line.startswith(filters_line_prefix):
                        filters_line = line[len(filters_line_prefix):].rstrip()
                    break
                if line.startswith(note_firstline):
                    found_autogenerated_line = True
                    # print("Found autogenerated disclaimer at line", i + 1)
        if not found_autogenerated_line and not args.update_manual:
            print("Not updating", args.source, "since it is not autogenerated.")
            sys.exit(0)
        if not args.filters and filters_line:
            args.filters = filters_line
            print("Inferred filters as '" + args.filters + "'")

        if "RUN: %clang_cc1 " not in first_line:
            sys.exit("When using --update the first line of the input file must contain RUN: %clang_cc1")
        clang_start = first_line.find("%clang_cc1") + len("%clang_cc1")
        file_check_idx = first_line.rfind("| FileCheck")
        if file_check_idx:
            dump_cmd = first_line[clang_start:file_check_idx]
        else:
            dump_cmd = first_line[clang_start:]
        print("Inferred run arguments as '", dump_cmd, "'", sep="")
        options = dump_cmd.split()
        if "-ast-dump=json" not in options:
            sys.exit("ERROR: RUN: line does not contain -ast-dump=json")
        if "%s" not in options:
            sys.exit("ERROR: RUN: line does not contain %s")
        options.remove("%s")
    else:
        options = args.opts.split()
        options.append("-ast-dump=json")
    cmd.extend(options)
    using_ast_dump_filter = any('ast-dump-filter' in arg for arg in cmd)
    cmd.append(args.source)
    print("Will run", cmd)
    filters = set()
    if args.filters:
        note += "\n" + filters_line_prefix + args.filters
        filters = set(args.filters.split(','))
    print("Will use the following filters:", filters)


    try:
        json_str = subprocess.check_output(cmd)
    except Exception as ex:
        print("The clang command failed with %s" % ex)
        return -1
    
    out_asts = []
    if using_ast_dump_filter:
        splits = re.split('Dumping .*:\n', json_str)
        if len(splits) > 1:
            for split in splits[1:]:
                j = json.loads(split.decode('utf-8'), object_pairs_hook=OrderedDict)
                normalize(j)
                out_asts.append(j)
    else:
        j = json.loads(json_str.decode('utf-8'), object_pairs_hook=OrderedDict)
        normalize(j)

        if len(filters) == 0:
            out_asts.append(j)
        else:
            #assert using_ast_dump_filter is False,\
            #    "Does not support using compiler's ast-dump-filter "\
            #    "and the tool's filter option at the same time yet."
        
            filter_json(j, filters, out_asts)
        
    with tempfile.NamedTemporaryFile("w") as f:
        with open(args.source, "r") as srcf:
            for line in srcf.readlines():
                # copy up to the note:
                if line.rstrip() == note_firstline:
                    break
                f.write(line)
        f.write(note + "\n")
        for out_ast in out_asts:
            append_str = json.dumps(out_ast, indent=1, ensure_ascii=False)
            out_str = '\n\n'
            index = 0
            for append_line in append_str.splitlines()[2:]:
                if index == 0:
                    out_str += '// CHECK: %s\n' %(append_line.rstrip())
                    index += 1
                else:
                    out_str += '// CHECK-NEXT: %s\n' %(append_line.rstrip())
                    
            f.write(out_str)
        f.flush()
        if args.update:
            print("Updating json appended source file to %s." %  args.source)
            copyfile(f.name, args.source)
        else:
            partition = args.source.rpartition('.')
            dest_path = '%s-json%s%s' % (partition[0], partition[1], partition[2])
            print("Writing json appended source file to %s." % dest_path)
            copyfile(f.name, dest_path)
    return 0
        
if __name__ == '__main__':
    main()
