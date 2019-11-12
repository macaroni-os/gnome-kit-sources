# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools gnome2

DESCRIPTION="Compiler for the GObject type system"
HOMEPAGE="https://wiki.gnome.org/Projects/Vala"

LICENSE="LGPL-2.1"
SLOT="0.42"
KEYWORDS="*"
IUSE="test"

COMMON_DEPEND="
	>=dev-libs/glib-2.62.2:2
	>=dev-libs/vala-common-${PV}
	dev-libs/libxslt
	>=media-gfx/graphviz-2.40.1
	dev-libs/gobject-introspection
"

RDEPEND="
	${COMMON_DEPEND}
	>=dev-libs/vala-common-${PV}
"

DEPEND="${COMMON_DEPEND}
	!${CATEGORY}/${PN}:0
	dev-libs/libxslt
	sys-devel/flex
	virtual/pkgconfig
	virtual/yacc
	>=media-gfx/graphviz-2.16
	test? ( dev-libs/dbus-glib )
"

PATCHES=(
	# Add missing bits to make valadoc parallel installable
	"${FILESDIR}"/vala-0.40-valadoc-doclets-data-parallel-installable.patch
)

src_configure() {
	# weasyprint enables generation of PDF from HTML
	gnome2_src_configure \
		--disable-unversioned \
		VALAC=: \
		WEASYPRINT=:
}

src_install() {
	default
	find "${D}" -name "*.la" -delete || die
}
