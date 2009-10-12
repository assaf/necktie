launch_dir["etc/cron/snapshot"].copy_to(box["/etc/cron.hourly/"]).access = { user_can: :read_write_execute, group_other_can: :read_execute }
