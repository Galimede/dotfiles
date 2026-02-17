function handy-toggle --description "Toggle handy speech-to-text recording, paste result on stop"
    set lock_file /tmp/handy-recording.lock
    set db ~/.local/share/com.pais.handy/history.db

    if test -f $lock_file
        # Was recording -> stop, transcribe, and paste
        set last_id (cat $lock_file)
        rm $lock_file
        pkill -USR2 -n handy

        # Poll for a new transcription (up to 5 seconds)
        set attempts 0
        while test $attempts -lt 25
            set new_text (sqlite3 "$db" "SELECT transcription_text FROM transcription_history WHERE id > $last_id ORDER BY id DESC LIMIT 1" 2>/dev/null)
            if test -n "$new_text"
                echo -n "$new_text" | wl-copy
                wtype -- "$new_text"
                return 0
            end
            sleep 0.2
            set attempts (math $attempts + 1)
        end
    else
        # Not recording -> start, save current max ID
        set max_id (sqlite3 "$db" "SELECT COALESCE(MAX(id), 0) FROM transcription_history" 2>/dev/null)
        echo "$max_id" >$lock_file
        pkill -USR2 -n handy
    end
end
