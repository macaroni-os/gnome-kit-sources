# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_USE_DEPEND="vapigen"

inherit gnome3 vala meson

DESCRIPTION="Make lines of the same color to win"
HOMEPAGE="https://wiki.gnome.org/Apps/Four-in-a-row"

# Code is GPL-2+ but most themes are GPL-3+ and we install them unconditionally, CC-BY-SA-3.0 is user help license in v3.22.1
LICENSE="GPL-3+ CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.62.2:2
	>=gnome-base/librsvg-2.32
	media-libs/gsound
	>=media-libs/libcanberra-0.26[gtk3]
	>=x11-libs/gtk+-3.24.12:3
"
DEPEND="${RDEPEND}
	app-text/yelp-tools
	dev-libs/appstream-glib
	>=dev-util/intltool-0.50
	virtual/pkgconfig
	${vala_depend}
"

src_prepare() {
	gnome3_src_prepare
	vala_src_prepare
}
