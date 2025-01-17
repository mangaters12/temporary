# sync rom
repo init --depth=1 --no-repo-verify -u git://github.com/NusantaraProject-ROM/android_manifest -b 11 -g default,-device,-mips,-darwin,-notdefault
git clone https://github.com/lavender/Local-Manifests.git --depth 1 -b master .repo/local_manifests
repo init --depth=1 --no-repo-verify -u https://github.com/NusantaraProject-ROM/android_manifest -b 11 -g default,-device,-mips,-darwin,-notdefault
git clone https://github.com/mangaters12/android_device_xiaomi_lavender-2.git --depth 1 -b main .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

# build rom
source .build/envsetup.sh
lunch nad_lavender-userdebug
export TZ=Asia/Dhaka #put before last build command
make nad

# upload rom (if you don't need to upload multiple files, then you don't need to edit next line)
rclone copy out/target/product/$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)/*.zip cirrus:$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1) -P
