# init.d script to start unicorn. we don't start the service yet, need to deploy
# rails app first, which we do with cap deploy:cold. only setup unicorn for now.
launch_dir["etc/init.d/unicorn"].copy_to(box["/etc/init.d/"]).access = { user_can: :read_write_execute, group_other_can: :read_execute }
