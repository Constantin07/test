import os
import re
import pytest

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


@pytest.mark.parametrize('binary', ['/usr/local/bin/ctop'])
def test_ctop(host, binary):
    f = host.file(binary)
    assert f.exists
    assert f.is_file
    assert f.user == 'root'
    assert f.group == 'root'
    assert oct(f.mode) == '0755'


@pytest.mark.parametrize('binary', ['/usr/local/bin/ctop'])
def test_ctop_version(host, binary):
    cmd = host.check_output(
            binary + " -v | sed  s/,// | awk '{print $3}'")
    assert re.match("^0.7.1", cmd)
