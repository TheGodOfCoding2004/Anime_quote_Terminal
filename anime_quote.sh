#!/bin/bash

# Function to fetch a random anime quote
function fetch_random_quote() {
    # Fetch quotes from the Yurippe API
    response=$(curl -s https://yurippe.vercel.app/api/quotes)

    # Check if the response is valid JSON
    if echo "$response" | jq empty > /dev/null 2>&1; then
        # Pick a random quote from the list
        quote=$(echo "$response" | jq -r '.[] | .quote' | shuf -n 1)
        character=$(echo "$response" | jq -r '.[] | select(.quote=="'"$quote"'") | .character')

        # Get terminal width
        terminal_width=$(tput cols)
        wrap_width=70

        # Wrap and center align the quote
        wrapped_quote=$(echo "$quote" | fmt -w $wrap_width | while read -r line; do
            printf "%*s\n" $(((${#line} + terminal_width) / 2)) "$line"
        done)

        # Center align the character name
        centered_character=$(printf "%*s\n" $(((${#character} + terminal_width) / 2)) "- $character")

        # Display the quote and character
        echo -e "\033[1;34m$wrapped_quote\033[0m"
        echo -e "\033[1;33m$centered_character\033[0m"
    else
        echo "Failed to fetch quotes. Check your internet connection or the API."
    fi
}

# Call the function
fetch_random_quote
