import requests
from requests.structures import CaseInsensitiveDict

url = "https://<YOUR_K8S_ENDPOINT>/api/v1/namespaces"

headers = CaseInsensitiveDict()
headers["Accept"] = "application/json"
headers["Authorization"] = "Bearer <BASE 64 DECODED TOKEN>"

resp = requests.get(url, headers=headers, verify=False)

if resp.status_code != 200:
    # This means something went wrong.
    raise ApiError('GET /tasks/ {}'.format(resp.status_code))

for namespace in resp.json()['items']:
    print('{}'.format(namespace['metadata']['name']))
