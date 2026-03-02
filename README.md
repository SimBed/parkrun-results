### Receive results from Park Run
Scrape public websites.  
Extract results of specified runners.  
Send email once all results in.  
Set up cron job locally for automation.

```
30 12-23 * * Fri ~/parkrun/bin/cancellation_monitor >> ~/parkrun/bin/log.txt 2>&1<br>
0 7-8 * * Sat ~/parkrun/bin/cancellation_monitor >> ~/parkrun/bin/log.txt 2>&1
```

set config/participants.yml
```
- name: "Martin Gichuhi"
  location: "ferry meadows"
- name: "Steven Baldwin"
  location: "huntingdon"
```

set configurations in .env<br>
create .env.secrets in root

```
### email
GMAIL_API_KEY=
EMAIL_FROM=
EMAIL_TO=
```

from project root:
```
$ ./bin/results
```

<img src="parkrun.svg" alt="demo image" width="300"><br>