for pattern_file in $HOME/.config/fabric/patterns/*
    # Get the base name of the file (i.e., remove the directory path)
    set pattern_name (basename "$pattern_file")

    # Create and evaluate the alias
    alias $pattern_name="fabric-ai --pattern $pattern_name"
end

function yt
    if test (count $argv) -eq 0 -o (count $argv) -gt 2
        echo "Usage: yt [-t | --timestamps] youtube-link"
        echo "Use the '-t' flag to get the transcript with timestamps."
        return 1
    end

    set transcript_flag "--transcript"
    if test "$argv[1]" = "-t" -o "$argv[1]" = "--timestamps"
        set transcript_flag "--transcript-with-timestamps"
        set video_link $argv[2]
    else
        set video_link $argv[1]
    end

    fabric-ai -y "$video_link" $transcript_flag
end

