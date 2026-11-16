function handy-toggle --description "Toggle handy speech-to-text recording"
    # Handy toggles start/stop on each SIGUSR2 and pastes the transcription
    # itself (paste_method in settings_store.json), so nothing else to do here.
    pkill -USR2 -n handy
end
