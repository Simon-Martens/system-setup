# Need gum to query for input
yay -S --noconfirm --needed gum

# Configure identification
echo -e "\nEnter identification for git and autocomplete..."
export system_setup_USER_NAME=$(gum input --placeholder "Enter full name" --prompt "Name> ")
export system_setup_USER_EMAIL=$(gum input --placeholder "Enter email address" --prompt "Email> ")
