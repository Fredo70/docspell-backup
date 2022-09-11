# docspell-backup

This is a small guide with a script to back up the DMS docspell periodically.
First of all, many thanks to Eikek for his excellent work on docspell.

## Purpose

Backup docspell with the help of a cron job. The file is then copied to a mounted directory (in my case a directory on a Synology). At the end, an email is sent with the script output.

## Disclaimer

I do not accept any responsibility for any damage that may occur as a result of this script or this manual. The use of the script or the following of this manual is at your own risk.

I also do not take any responsibility that the backup will be complete and usable.

I take no responsibility for external content and external links.

## My Background

I have basic knowledge of Linux, but I am not a specialist. I have only worked very little with Linux so far. To accomplish this, Google was my companion.

Therefore, this script does not claim to be correct or "state of the art". Maybe it can be improved. Maybe someone else would do it completely differently.

If anyone has to shake their head while reading it, feel free to send me their suggestions before you get a shaking impact syndrome.

## Prerequisites

* Ubuntu 22.04 (Of course, it can also run on other distributions or versions, but I don't know).
* docspell run with docker-compose. See the documentation at [https://docspell.org/](https://docspell.org/).
* Packages *mailutils* and *ssmtp* installed. Note: I chose *ssmtp* because I spent a whole afternoon trying to set up *postfix* without success. *sendmail* should also be an alternative.
* Some basic knowledge to understand what you are doing :-)

## What does the script do?

* Creates a dump of the SQL database.
* Check that the file has been created.
* Check that the remote directory is mounted.
* Copy the backup file to the remote directory.
* Check that the 2 files are identical.
* Delete the backup file that was created first.

## Setup

1. Read and understand [this documentation](https://docspell.org/docs/install/docker/#backups). Note the indentation in the file `docker-compose.override.yml`. It may be that a TAB is missing in the example. My file is in the repository. You can simply adjust the path according to your own needs.<br>
This documentation also describes the docker command to execute the dump. However, in this command I had to remove the "-it" arguments so that it can be executed by Cron.
1. Create the script and make it executable. You have to adapt the variables (at the top of the script) to your own configuration.
1. Setup *ssmtp*. I have used these [instructions](https://decatec.de/home-server/linux-einfach-e-mails-senden-mit-ssmtp/). It's in German, but I'm sure you can find something in English or in your language.
1. Setup crontab. In the repository is the crontab file of my root user as an example. Please do not edit the crontab file directly! Use the command `sudo crontab -e`. In my file, the job should run every Sunday at 10pm.<br>
Note the line with `MAILTO="RecipentEMail@xxxx.com"`. Set the e-mail address that is to receive the mail here.

## Example output in e-mail

    2022-09-10 20:08:01 Backup file: /home/minix/docspellbackup/20220910_docspell.sqlc
    2022-09-10 20:08:01 Mount point: /mnt/backup_ecoDMS 

    2022-09-10 20:08:01 Start backup... OK
    2022-09-10 20:09:33 Check if backup file was created... OK
    2022-09-10 20:09:33 Check if we have the remote directory mounted... OK
    2022-09-10 20:09:33 Copy the backup file to the remote directory... OK
    2022-09-10 20:10:08 Check if both files are the same... OK
    2022-09-10 20:11:06 Remove the backup file on this machine... OK
