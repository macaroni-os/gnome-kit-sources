# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python3_{4,5,6,7} )

inherit gnome.org gnome2-utils meson python-any-r1 systemd xdg

DESCRIPTION="Collection of data extractors for Tracker/Nepomuk"
HOMEPAGE="https://wiki.gnome.org/Projects/Tracker"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"
IUSE="cue exif ffmpeg flac gif gsf +gstreamer iptc +iso +jpeg libav +pdf +playlist raw +rss test +taglib +tiff upower +vorbis +xml xmp xps"

REQUIRED_USE="cue? ( gstreamer )" # cue is currently only supported via gstreamer, not ffmpeg/libav

KEYWORDS="*"

# tracker-2.1.7 currently always depends on ICU (theoretically could be libunistring instead); so choose ICU over enca always here for the time being (ICU is preferred)
RDEPEND="
	>=dev-libs/glib-2.62.2:2
	>=app-misc/tracker-2.2.1:=
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0 )
	!gstreamer? (
		ffmpeg? (
			libav? ( media-video/libav:0= )
			!libav? ( media-video/ffmpeg:0= ) ) )

	>=sys-apps/dbus-1.3.1
	xmp? ( >=media-libs/exempi-2.1.0:= )
	flac? ( >=media-libs/flac-1.2.1 )
	raw? ( media-libs/gexiv2 )
	>=dev-libs/icu-4.8.1.2:=
	cue? ( media-libs/libcue )
	exif? ( >=media-libs/libexif-0.6 )
	gsf? ( >=gnome-extra/libgsf-1.14.24:= )
	xps? ( app-text/libgxps )
	iptc? ( media-libs/libiptcdata )
	jpeg? ( virtual/jpeg:0 )
	iso? ( >=sys-libs/libosinfo-0.2.10 )
	>=media-libs/libpng-1.2:0=
	>=sys-libs/libseccomp-2.0
	tiff? ( media-libs/tiff:0 )
	xml? ( >=dev-libs/libxml2-2.6 )
	vorbis? ( >=media-libs/libvorbis-0.22 )
	pdf? ( >=app-text/poppler-0.16.0[cairo] )
	taglib? ( >=media-libs/taglib-1.6 )
	playlist? ( >=dev-libs/totem-pl-parser-3:= )
	upower? ( >=sys-power/upower-0.9.0 )
	sys-libs/zlib:0
	gif? ( media-libs/giflib:= )

	rss? ( >=net-libs/libgrss-0.7:0 )
	app-arch/gzip
"
DEPEND="${RDEPEND}
	dev-util/glib-utils

	>=dev-util/intltool-0.40.0
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	test? ( ${PYTHON_DEPS} )
"
# intltool-merge manually called in meson.build in 2.1.5; might be properly gone by 2.2.0 (MR !29)

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	xdg_src_prepare
	gnome2_environment_reset # sets gstreamer safety variables
}

src_configure() {
	local media_extractor="none"
	if use gstreamer ; then
		media_extractor="gstreamer"
	elif use ffmpeg ; then
		media_extractor="libav"
	fi

	local emesonargs=(
		-Dtracker_core=system

		-Ddocs=true
		-Dextract=true
		$(meson_use test functional_tests)
		-Dminer_apps=true
		-Dminer_fs=true
		$(meson_use rss miner_rss)
		-Dwriteback=true
		-Dabiword=true
		-Ddvi=true
		-Dicon=true
		-Dmp3=true
		-Dps=true
		-Dtext=true
		-Dunzip_ps_gz_files=true # spawns gunzip

		-Dcue=$(usex cue enabled disabled)
		-Dexif=$(usex exif enabled disabled)
		-Dflac=$(usex flac enabled disabled)
		-Dgif=$(usex gif enabled disabled)
		-Dgsf=$(usex gsf enabled disabled)
		-Diptc=$(usex iptc enabled disabled)
		-Diso=$(usex iso enabled disabled)
		-Djpeg=$(usex jpeg enabled disabled)
		-Dpdf=$(usex pdf enabled disabled)
		-Dplaylist=$(usex playlist enabled disabled)
		-Dpng=enabled
		-Draw=$(usex raw enabled disabled)
		-Dtaglib=$(usex taglib enabled disabled)
		-Dtiff=$(usex tiff enabled disabled)
		-Dvorbis=$(usex vorbis enabled disabled)
		-Dxml=$(usex xml enabled disabled)
		-Dxmp=$(usex xmp enabled disabled)
		-Dxps=$(usex xps enabled disabled)

		-Dbattery_detection=$(usex upower upower none)
		-Dcharset_detection=icu # enca is a possibility, but right now we have tracker core always dep on icu and icu is preferred over enca
		-Dgeneric_media_extractor=${media_extractor}
		# gupnp gstreamer_backend is in bad state, upstream suggests to use discoverer, which is the default
		-Dsystemd_user_services="$(systemd_get_userunitdir)"
	)
	meson_src_configure
}

src_test() {
	dbus-run-session meson test -C "${BUILD_DIR}" || die 'tests failed'
}
