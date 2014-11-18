#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import unicode_literals
from __future__ import division
from __future__ import absolute_import
from __future__ import print_function

import subprocess
import argparse
import sys
import os

def run(cmd):
    proc = subprocess.Popen(cmd, shell=True)
    proc.wait()

def start_omero_server():
    try:
        proc = subprocess.Popen(["/usr/bin/supervisord", "-c",
                                 "/etc/supervisor/conf.d/omero_supervisor.conf"])
        proc.communicate()

    except KeyboardInterrupt:
        pass

def start_bash():
    try:
        proc = subprocess.Popen(["/bin/bash"])
        proc.communicate()
    except KeyboardInterrupt:
        pass

def restore_database(path_db):
    print("Restore database from {}".format(path_db))

    # Get database name inside archive
    dbname = subprocess.check_output("tar -tf {} | head -1".format(path_db), shell=True)

    # Decompress archive
    run("tar xjf {} -C /tmp".format(path_db))

    # Start database
    run("service postgresql start")

    # Drop database
    run("sudo -u postgres dropdb omero")

    # Create database
    run("sudo -u postgres createdb omero")

    # Restore database
    uncompressed_db_path = os.path.join("tmp", dbname)
    cmd = 'sudo -u postgres pg_restore -Fc --verbose -d omero {}'.format(uncompressed_db_path)
    run(cmd)

    # Stop database
    run("service postgresql stop")

    # Remove uncompressed database file
    run("rm -f {}".format(uncompressed_db_path))

if __name__ == '__main__':

    parser = argparse.ArgumentParser()
    parser.add_argument('--restore', type=str, default=None,
                        help="""Restore a database backup using data volume container."""
                             """ Ex: --restore /data/backups/2014_11_15_15_36_omero_db.tar.bz2""")
    parser.add_argument('--restore-last', action='store_true',
                        help="Restore the last backup found in /data/backups")
    parser.add_argument('--bash', action='store_true',
                        help="""Start bash shell.""")

    args = parser.parse_args()

    if args.bash:
        start_bash()
        sys.exit(0)

    if args.restore:
        restore_database(args.restore)

    elif args.restore_last:
        backups = sorted(os.listdir('/data/backups'))
        last_backup = os.path.join("/data/backups", backups[-1])
        restore_database(last_backup)

    start_omero_server()
    sys.exit(0)
