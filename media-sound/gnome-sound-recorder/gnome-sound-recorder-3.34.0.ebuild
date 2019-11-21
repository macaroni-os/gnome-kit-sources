# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2 meson

DESCRIPTION="Simple sound recorder"
HOMEPAGE="https://wiki.gnome.org/Design/Apps/SoundRecorder"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="*"
IUSE=""

COMMON_DEPEND="
	dev-libs/gjs
	>=dev-libs/glib-2.62.2:2
	>=>=dev-libs/gobject-introspection-1.62.0:=.31.6
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.24.12:3[introspection]
"
RDEPEND="${COMMON_DEPEND}
	media-libs/gstreamer:1.0[introspection]
	media-libs/gst-plugins-base:1.0[introspection,ogg]
	media-libs/gst-plugins-bad:1.0
	media-libs/gst-plugins-good:1.0
	media-plugins/gst-plugins-flac:1.0
	media-plugins/gst-plugins-pulse:1.0

"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.26
	virtual/pkgconfig
"

src_prepare() {
	gnome2_src_prepare
}
