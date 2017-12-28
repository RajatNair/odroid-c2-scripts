
#!/bin/bash
### Script to update Beets on Odroid C2 running Ubuntu 16.04
### maintained by Aunlead

# Update PIP
python -m pip install -U pip

pip install beets -v --upgrade

echo 'Update complete'


