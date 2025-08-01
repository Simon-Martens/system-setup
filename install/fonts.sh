yay -Sy --noconfirm --needed ttf-font-awesome noto-fonts noto-fonts-emoji noto-fonts-cjk noto-fonts-extra nerd-fonts ttf-google-fonts-git ttf-linux-libertine otf-baskervillef ttf-croscore gnu-free-fonts ttf-ms-win10-auto ttf-liberation ttf-heuristica otf-crimson ttf-bitstream-vera otf-bitstream-charter ttf-gentium-plus otf-jost ttf-dmcasansserif 

mkdir -p ~/.local/share/fonts

if ! fc-list | grep -qi "iA Writer Mono S"; then
  cd /tmp
  wget -O iafonts.zip https://github.com/iaolo/iA-Fonts/archive/refs/heads/master.zip
  unzip iafonts.zip -d iaFonts
  cp iaFonts/iA-Fonts-master/iA\ Writer\ Mono/Static/iAWriterMonoS-*.ttf ~/.local/share/fonts
  rm -rf iafonts.zip iaFonts
  fc-cache
  cd -
fi

cp -Rf ~/.local/share/omarchy/.fonts ~
fc-cache -f
