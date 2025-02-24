# https://gist.github.com/nikoheikkila/dd4357a178c8679411566ba2ca280fcc?permalink_comment_id=4747845#gistcomment-4747845
function envsource
    set -f envfile "$argv"
    if not test -f "$envfile"
        echo "Unable to load $envfile"
        return 1
    end
    while read line
        if not string match -qr '^#|^$' "$line" # skip empty lines and comments
            if string match -qr '=' "$line" # if `=` in line assume we are setting variable.
                set item (string split -m 1 '=' $line)
                set item[2] (eval echo $item[2]) # expand any variables in the value
                set -gx $item[1] $item[2]
            else
                eval $line # allow for simple commands to be run e.g. cd dir/mamba activate env
            end
        end
    end < "$envfile"
end
