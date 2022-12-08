import argparse
import json
import subprocess

parser = argparse.ArgumentParser()

parser.add_argument("--compose", help="Docker Compose File")
parser.add_argument("--module", help="Output Module")

args = parser.parse_args()

compose = args.compose
module = args.module

command = f'docker compose -f {compose} run --rm terraform output -json {module}'
process = subprocess.run(command, shell=True, stdout=subprocess.PIPE)
result = process.stdout.decode('utf-8')

try:
    output = json.loads(result)
    for item in output:
        print(f"{item}={output[item]}")
except Exception as e:
    print(f'No output for {module} | {e}\n')
