# Production Deployment Plan: [feat:purchase-request-reimplementation]

- **Date:** 2026-06-05
- **Pull Request:** [Link to PR]

---

## 1. Pre-Deployment Checklist
*Must be completed BEFORE the maintenance window starts.*
- [ ] **Backup:**
  Perform a full database backup
  ```bash
  pg_dump -U [your_username] -h [your_host] -p [your_port] [your_database_name] > <dbname>.bak.sql
  # run this on the root
  ```

  Perform Project Folder backup
  ```bash
  sudo cp -r <project_dir> <project_name>.bak
  ```

  stop service name
  ```bash
  sudo systemctl stop <service_name>
  ```

- [ ] **Test Deployment**
  - [ ] Make a copy of the running instance app
  ```bash
  cp -r ~/path/to/project/ ~/DevApps/<project_name>
  ```
  - [ ] Change database config to dev and test
  - [ ] follow the implementation steps

## 2. Implementation Steps
*Execute these steps in order.*
1. **Get new changes:** run `git pull origin main`  
2. **Database Migrations:** Run `bunde exec rails db:migrate`.
3. **Seed Data:**  run `bundle exec rake db:seed:<seed_file>` for Donor, Budget Line, Donor_Project data
4. **Test application:** run `bundle exec rails s -b 0.0.0.0`
5. **Restart Service:** `sudo systemctl restart <app>.service && sudo systemctl status <app>.service`

## 3. Verification (Sanity Checks)
*How to confirm everything is working.*
- [ ] **Health Check:** visit url, view a timesheet, test a purchase request

## 4. Rollback Plan
*If verification fails, follow these steps to revert.*
1. **Revert Code:** move current code to `~/Fail/<app>.fail` and run `sudo cp -r <project_name>.bak ~/path/to/project/` to restore the previous codebase.
2. **Restore DB:** if it fails on test, do not restore as the databases are _dev and _test. If it fails on production, run `psql -U [your_username] -h [your_host] -p [your_port] [your_database_name] < <dbname>.bak.sql` to restore the database.
3. **Notify:** Update the team
