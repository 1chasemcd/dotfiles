import subprocess, json

json_string = subprocess.check_output(["i3-msg", "-t", "get_workspaces"])

workspaces = json.loads(json_string)

max_num = 0

for w in workspaces:
    if w['num'] > max_num:
        max_num = w['num']

subprocess.call(["i3-msg", "workspace", "number", str(max_num + 1)])
