import base64
import os
from base64 import b64encode

header = """apiVersion: v1
kind: Secret
metadata:
  name: {}-secret
type: kubernetes.io/Opaque
data:
"""

env_file_names = filter(lambda x: '.env' in x and 'sample' not in x, filter(os.path.isfile, os.listdir(os.curdir)))
for env_file_name in env_file_names:
    name = env_file_name.split('.')[0]
    data = header.format(name)
    with open(env_file_name, 'r') as env_file:
        lines = env_file.read().split('\n')
        for line in lines:
            if line:
                key, value = line.split('=')
                data += f'    {key}: {b64encode(value.encode("utf-8")).decode("utf-8")}\n'

    data += f'    BAD_RS_PRIVATE_KEY: {bad_private_key_double_base64_encoded}\n'
    data += f'    GOOD_RS_PRIVATE_KEY: {good_private_key_double_base64_encoded}\n'
    with open(f'{name}.yaml', 'w') as secret_file:
        secret_file.write(data)
