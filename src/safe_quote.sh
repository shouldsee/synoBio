#!/bin/bash
safe_quote ()
{
    local x="$@";
    echo $(printf '%q' "$x")
}
safe_quote "$@"
