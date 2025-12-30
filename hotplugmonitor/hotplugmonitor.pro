TEMPLATE = subdirs
CONFIG  += ordered
!android:!ios {
SUBDIRS += src
!notests: SUBDIRS += test
}
