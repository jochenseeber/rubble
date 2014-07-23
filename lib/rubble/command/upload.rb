require 'rubble/command/base'
require 'docile'

module Rubble
    module Command
        class Upload < Base
            def execute
                snapshot = resource.snapshot
                target_dir = File.join(deploy_dir, snapshot.version)

                @log.debug("Uploading snapshot #{snapshot}")

                remote.mkdir(target_dir)
                remote.cd(deploy_dir, true)

                if not snapshot.empty? then
                    if remote.file_exists?('current') then
                        # remote.rsync('current/', "#{snapshot.version}/")
                    end

                    remote.sync_up(snapshot.filesets, target_dir)
                end

                remote.symlink(snapshot.version, 'current')
            end
        end
    end
end
