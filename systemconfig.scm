;; This is an operating system configuration generated
;; by the graphical installer.
;;
;; Once installation is complete, you can learn and modify
;; this file to tweak the system configuration, and pass it
;; to the 'guix system reconfigure' command to effect your
;; changes.


;; Indicate which modules to import to access the variables
;; used in this configuration.
(use-modules (gnu)
	     (nongnu packages linux)
	     (nongnu system linux-initrd))
(use-service-modules desktop networking xorg)

(operating-system
  (kernel linux)
  (firmware (list linux-firmware))
  (initrd microcode-initrd)
  (locale "en_IN.utf8")
  (timezone "Asia/Kolkata")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "T480guix")

  ;; The list of user accounts ('root' is implicit).
  (users (cons* (user-account
                  (name "ganeshguix")
                  (comment "Ganesh")
                  (group "users")
                  (home-directory "/home/ganeshguix")
                  (supplementary-groups '("wheel" "netdev" "audio" "video")))
                %base-user-accounts))

  (bootloader (bootloader-configuration
                (bootloader grub-bootloader)
                (targets (list "/dev/sda1"))
                (keyboard-layout keyboard-layout)))
  
  (mapped-devices (list (mapped-device
			  (source "internalssd")
			  (targets (list "internalssd-guixroot" "internalssd-guixhome" "internalssd-guixswap"))
			  (type lvm-device-mapping))))
  
  (swap-devices (list (swap-space
                       (target "/dev/mapper/internalssd-guixswap")
		       (dependencies mapped-devices))))

  ;; The list of file systems that get "mounted".  The unique
  ;; file system identifiers there ("UUIDs") can be obtained
  ;; by running 'blkid' in a terminal.
  (file-systems (cons* (file-system
                         (mount-point "/")
                         (device "/dev/mapper/internalssd-guixroot")
                         (type "ext4")
			 (dependencies mapped-devices))
                        (file-system
                         (mount-point "/home")
                         (device "/dev/mapper/internalssd-guixhome")
                         (type "ext4")
			 (dependencies mapped-devices))  %base-file-systems)))

  ;; Below is the list of system services.  To search for available
  ;; services, run 'guix system search KEYWORD' in a terminal.
  (services
   (append (list (service gnome-desktop-service-type)
                 (set-xorg-configuration
                  (xorg-configuration (keyboard-layout keyboard-layout))))

           ;; This is the default list of services we
           ;; are appending to.
           %desktop-services)
   (modify-services %desktop-services
    (guix-service-type config => (guix-configuration
      (inherit config)
      (substitute-urls
       (append (list "https://substitutes.nonguix.org")
         %default-substitute-urls))
      (authorized-keys
       (append (list (plain-file "non-guix.pub"
                                 "(public-key (ecc (curve Ed25519) (q #C1FD53E5D4CE971933EC50C9F307AE2171A2D3B52C804642A7A35F84F3A4EA98#)))"))
               %default-authorized-guix-keys)))))))
