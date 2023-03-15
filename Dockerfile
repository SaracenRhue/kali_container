FROM kalilinux/kali-rolling:latest

# Install dependencies
RUN apt update
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata.
RUN apt install -y sudo ssh nvidia-cuda-toolkit nvidia-driver

# Add a new user
RUN useradd -ms /bin/bash user && \
    echo "user:password" | chpasswd && \
    adduser user sudo

# setup zsh
RUN apt install -y zsh zsh-autosuggestions zsh-syntax-highlighting neofetch && \
    echo "plugins=(zsh-autosuggestions)" >> ~/.zshrc && \
    git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k && \
    echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> ~/.zshrc && \
    curl -L http://install.ohmyz.sh | sh && \
    chsh -s $(which zsh) user && \
    echo "neofetch" >> ~/.zshrc

# Expose port 22
ENV PORT=22
EXPOSE 22

# VOLUME /home/user

# Start SSH service
RUN mkdir /var/run/sshd
CMD /usr/sbin/sshd -D
