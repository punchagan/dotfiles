#!/home/punchagan/.virtualenvs/py3/bin/python

import requests
from readability.readability import Document

def get_content(url):
    try:
        response = requests.get(url, timeout=10)

    except requests.ConnectionError:
        print('Error connecting to {}'.format(url))

    else:
        # Only store the content if the page load was successful
        if response.ok:
            page_content = Document(response.content).summary()
            print(page_content)

        else:
            print('Error processing URL({}): {}'.format(url, response.reason))



if __name__ == '__main__':
    import sys
    if len(sys.argv) != 2:
        sys.exit('Usage: {} <URL>'.format(sys.argv[0]))
    url = sys.argv[1]
    get_content(url)
