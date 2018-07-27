FROM sailfishos-platform-sdk-base
MAINTAINER Lucien Xu <sfietkonstantin@free.fr>

ARG extra_packages

ARG tooling_url
ARG target_arm_url
ARG target_486_url

ARG name_tooling
ARG name_arm_target
ARG name_486_target

ARG local_uid
ARG local_gid

# Allow any user use sudo without password
RUN chmod +w /etc/sudoers && echo "ALL ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && chmod -w /etc/sudoers

RUN groupadd -g $local_gid -r user && useradd -u $local_uid -g user -r -m user

COPY sdk_bash_completion.sh /etc/profile.d/

USER user

RUN sudo zypper ref
RUN sudo zypper -qn in $extra_packages

RUN sdk-assistant -y create $name_tooling $tooling_url
COPY mer-tooling-chroot /srv/mer/toolings/$name_tooling/

RUN sdk-assistant -y create $name_arm_target $target_arm_url

RUN sdk-assistant -y create $name_486_target $target_486_url