
# install
```
wget https://www.atomicorp.com/OSSEC-ARCHIVE-KEY.asc
gpg --import OSSEC-ARCHIVE-KEY.asc


wget https://github.com/ossec/ossec-hids/archive/3.6.0.tar.gz
wget https://github.com/ossec/ossec-hids/releases/download/3.6.0/ossec-hids-3.6.0.tar.gz.asc

gpg --verify ossec-hids-3.6.0.tar.gz.asc 3.6.0.tar.gz

tar -vfx 3.6.0.tar.gz && \
rm -rf 3.6.0.tar.gz 
cd 3.6.0

```

# Configure as local


sudo find / -name 'ossec.conf'  2>&1 | grep -v find
// find with silent stdout


Process Monitoring
Overview

We love logs. Inside OSSEC we treat everything as if it is a log and parse it appropriately with our rules. However, some information is not available in log files but we still want to monitor it. To solve that gap, we added the ability to monitor the output of commands via OSSEC, and treat the output of those commands just like they were log files.
Configuration examples
Disk space utilization (df -h) example

For example, if you wanted to monitor the disk space utilization, you would need to setup a cron job to dump the output of df -h to a log file (maybe /var/log/df.log) and configure OSSEC to look at it.

As of OSSEC version 2.3 you can monitor commands directly in OSSEC following configuration (in /var/ossec/etc/ossec.conf):


File: /var/ossec/etc/ossec.conf

<ossec_config>

  <syslog_output>
    <server>192.168.4.1</server>
    <port>12323</port>
  </syslog_output>


  <global>
    <jsonout_output>yes</jsonout_output>
    ...
  </global>
  ...
</ossec_config>

/var/ossec/bin/ossec-control enable client-syslog
# check
tail -n 1000 /var/ossec/logs/ossec.log | grep csyslog

# The above settings formats to json for easy parsing with fluentd

<localfile>
    <log_format>command</log_format>
    <command>df -h</command>
</localfile>

Since we already have a sample rule for df -h included with OSSEC you would see the following when any partition reached 100%:

** Alert 1257451341.28290: mail - ossec,low_diskspace,
2009 Nov 05 16:02:21 (home-ubuntu) 192.168.0.0->df -h

Rule: 531 (level 7) -> "Partition usage reached 100% (disk space monitor)."
Src IP: (none)
User: (none)
ossec: output: 'df -h': /dev/sdb1 24G 12G 11G 100% /var/backup

Load average (uptime) Example

Another example, if you want to monitor the load average, you can configure OSSEC to monitor the “uptime” command and alert when it is higher than 2, for example:

<localfile>
    <log_format>command</log_format>
    <command>uptime</command>
</localfile>

And in the rule (in /var/ossec/rules/local_rules.xml):

<rule id="100101" level="7" ignore="7200">
    <if_sid>530</if_sid>
    <match>ossec: output: 'uptime': </match>
    <regex>load averages: 2.</regex>
    <description>Load average reached 2..</description>
</rule>


Alerting when output of a command changes

If you want to create alerts when a log or the output of a command changes, take a look at the new <check_diff /> option in the rules (available on the latest snapshot).

To demonstrate with an example, we will create a rule to alert when there is a new port open in listening mode on our server.

First, we configure OSSEC to run the netstat -tan |grep LISTEN command by adding the following to ossec.conf:

<localfile>
    <log_format>full_command</log_format>
    <command>netstat -tan |grep LISTEN|grep -v 127.0.0.1</command>
</localfile>

After that, I add a rule to alert when its output changes:

<rule id="140123" level="7">
    <if_sid>530</if_sid>
    <match>ossec: output: 'netstat -tan |grep LISTEN</match>
    <check_diff />
    <description>Listened ports have changed.</description>
</rule>

Note that we use the <check_diff /> option. The first time it receives the event, it will store in an internal database. Every time it receives the same event, it will compare against what we have store and only alert if the output changes.

In our example, after configuring OSSEC, I started netcat to listen on port 23456 and that’s the alert I got:

OSSEC HIDS Notification.
2010 Mar 11 19:56:30

Received From: XYZ->netstat -tan |grep LISTEN|grep -v 127.0.0.1
Rule: 140123 fired (level 7) -> "Listened ports have changed."
Portion of the log(s):

ossec: output: 'netstat -tan |grep LISTEN|grep -v 127.0.0.1':
tcp4       0      0 *.23456           *.*               LISTEN
tcp4       0      0 *.3306            *.*               LISTEN
tcp4       0      0 *.25              *.*               LISTEN
Previous output:
ossec: output: 'netstat -tan |grep LISTEN|grep -v 127.0.0.1':
tcp4       0      0 *.3306            *.*               LISTEN
tcp4       0      0 *.25              *.*               LISTEN

Configuration examples
Simple example

Configuring a log file to be monitored is simple. Just provide the name of the file to be monitored and the format:

<localfile>
    <location>/var/log/messages</location>
    <log_format>syslog</log_format>
</localfile>


Multiple Files Example

To check multiple files, OSSEC supports posix regular expressions. For example, to analyze every file that ends with a .log inside the /var/log directory, use the following configuration:

<localfile>
    <location>/var/log/*.log</location>
    <log_format>syslog</log_format>
</localfile>


SYSLOG: INTEGRITY MON


Configuration options

These configuration options can be specified in each agent’s ossec.conf file, except for the auto_ignore and alert_new_file which apply to manager and local installs. The ignore option applies to all agents if specified on the manager.

directories

    Use this option to add or remove directories to be monitored (they must be comma separated). All files and subdirectories will also be monitored. Drive letters without directories are not valid. At a minimum the ‘.’ should be included (D:\.). This should be set on the system you wish to monitor (or in the agent.conf if appropriate).

    Default: /etc,/usr/bin,/usr/sbin,/bin,/sbin

    Attributes:

        realtime: Value=yes

                This will enable realtime/continuous monitoring on Linux (using the inotify system calls) and Windows systems.

        report_changes: Value=yes

                Report diffs of file changes. This is limited to text files at this time.

            This option is only available on Unix-like systems.

        check_all: Value=yes

                All the following check_* options are used together unless a specific option is explicitly overridden with “no”.

        check_sum: Value=yes

                Check the md5 and sha1 hashes of the of the files will be checked.

                This is the same as using both check_sha1sum=”yes” and check_md5sum=”yes”

        check_sha1sum: Value=yes

                When used only the sha1 hash of the files will be checked.

        check_md5sum: Value=yes

                The md5 hash of the files will be checked.

        check_size: Value=yes

                The size of the files will be checked.

        check_owner: Value=yes

                Check the owner of the files selected.

        check_group: Value=yes

                Check the group owner of the files/directories selected.

        check_perm: Value=yes

                Check the UNIX permission of the files/directories selected. On windows this will only check the POSIX permissions.

        restrict: Value=string

                A string that will limit checks to files containing that string in the file name.

            Allowed: Any directory or file name (but not a path)

        no_recurse: Value=no

            New in version 3.2.
                Do not recurse into the defined directory.

            Allowed: yes/no

ignore

    List of files or directories to be ignored (one entry per element). The files and directories are still checked, but the results are ignored.

    Default: /etc/mtab

    Attributes:

        type: Value=sregex

                This is a simple regex pattern to filter out files so alerts are not generated.

    Allowed: Any directory or file name

nodiff

    New in version 3.0.

    List of files to not attach a diff. The files are still checked, but no diff is computed. This allows to monitor sensitive files like private key or database configuration without leaking sensitive data through alerts.

    Attributes:

        type: Value=sregex

                This is a simple regex pattern to filter out files so alerts are not generated.

    Allowed: Any directory or file name

frequency

    Frequency that the syscheck is going to be executed (in seconds).

    The default is 6 hours or 21600 seconds

    Default: 21600

    Allowed: Time in seconds

scan_time

    Time to run the scans (can be in the formats of 21pm, 8:30, 12am, etc).

    Allowed: Time to run scan

    This may delay the initialization of realtime scans.

scan_day

    Day of the week to run the scans (can be in the format of sunday, saturday, monday, etc)

    Allowed: Day of the week

auto_ignore

    Specifies if syscheck will ignore files that change too often (after the third change)

    Default: yes

    Allowed: yes/no

    Valid: server, local

alert_new_files

    Specifies if syscheck should alert on new files created.

    Default: no

    Allowed: yes/no

    Valid: server, local

    New files will only be detected on a full scan, this option does not work in realtime.

scan_on_start

    Specifies if syscheck should do the first scan as soon as it is started.

    Default: yes

    Allowed: yes/no

windows_registry

    Use this option to add Windows registry entries to be monitored (Windows-only).

    Default: HKEY_LOCAL_MACHINESoftware

    Allowed: Any registry entry (one per element)

    New entries will not trigger alerts, only changes to existing entries.

registry_ignore

    List of registry entries to be ignored.

    Default: ..CryptographyRNG

    Allowed: Any registry entry (one per element)

refilter_cmd

    Command to run to prevent prelinking from creating false positives.

    Example:

    <prefilter_cmd>/usr/sbin/prelink -y</prefilter_cmd>

    This option can potentially impact performance negatively. The configured command will be run for each and every file checked.

skip_nfs

    New in version 2.9.0.

    Specifies if syscheck should scan network mounted filesystems. Works on Linux and FreeBSD. Currently skip_nfs will abort checks running against CIFS or NFS mounts.

    Default: no

    Allowed: yes/no

    This option was added in OSSEC 2.9.

Configuration Examples

To configure syscheck, a list of files and directories must be provided. The check_all option checks md5, sha1, owner, and permissions of the file.

Example:

<syscheck>
    <directories check_all="yes">/etc,/usr/bin,/usr/sbin</directories>
    <directories check_all="yes">/root/users.txt,/bsd,/root/db.html</directories>
</syscheck>

Files and directories can be ignored using the ignore option (or registry_ignore for Windows registry entries):

<syscheck>
    <ignore>/etc/random-seed</ignore>
    <ignore>/root/dir</ignore>
    <ignore type="sregex">.log$|.tmp</ignore>
</syscheck>

The type attribute can be set to sregex to specify a Regular Expression Syntax in the ignore option.

<syscheck>
    <ignore type="sregex">^/opt/application/log</ignore>
</syscheck>

A local rule can be used to modify the severity for changes to specific files or directories:

<rule id="100345" level="12">
    <if_matched_group>syscheck</if_matched_group>
    <match>/var/www/htdocs</match>
    <description>Changes to /var/www/htdocs - Critical file!</description>
</rule>

In the above example, a rule was created to alert with high severity (12) for changes to the files in the htdocs directory.
Real time Monitoring

OSSEC supports realtime (continuous) file integrity monitoring on Linux (support was added kernel version 2.6.13) and Windows systems.

The configuration is very simple. In the <directories> option where you specify what directories to monitor, adding realtime="yes" will enable it. For example:

<syscheck>
    <directories realtime="yes" check_all="yes">/etc,/usr/bin,/usr/sbin</directories>
    <directories check_all="yes">/bin,/sbin</directories>
</syscheck>

In this case, the directories /etc, /usr/bin and /usr/sbin will be monitored in real time. The same applies to Windows too.

The real time monitoring will not start immediately. First ossec-syscheckd needs to scan the file system and add each sub-directory to the realtime queue. It can take a while for this to finish (wait for the log “ossec-syscheckd: INFO: Starting real time file monitoring” ).

Real time only works with directories, not individual files. So you can monitor the /etc or C:\program files directory, but not an individual file like /etc/file.txt.

Both rootcheck and syscheck runs on the same thread, so when rootcheck is running, the inotify events would get queued until it finishes.
Report Changes

OSSEC supports sending diffs when changes are made to text files on Linux and unix systems.

Configuring syscheck to show diffs: 
add report_changes="yes" to the <directories> option. For example:

<syscheck>
    <directories report_changes="yes" check_all="yes">/etc</directories>
    <directories check_all="yes">/bin,/sbin</directories>
</syscheck>

Report Changes can only work with text files, and the changes are stored on the agent inside /var/ossec/queue/diff/local/dir/file.

If OSSEC has not been compiled with libmagic support, report_changes will copy any file designated, e.g. mp3, iso, executable, /chroot/dev/urandom (which would fill your hard drive). So unless libmagic is used, be very carefull on which directory you enable report_changes.
