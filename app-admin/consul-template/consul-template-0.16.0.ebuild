# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-base systemd user

KEYWORDS="~amd64"
DESCRIPTION="Generic template rendering and notifications with Consul"
EGO_PN="github.com/hashicorp/${PN}/..."
HOMEPAGE="http://${EGO_PN%/*}"
LICENSE="MPL-2.0"
SLOT="0"
IUSE=""
RESTRICT="test"

DEPEND=">=dev-lang/go-1.6:="
RDEPEND=""

SRC_URI="https://${EGO_PN%/*}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/mitchellh/gox/archive/c9740af9c6574448fd48eb30a71f964014c7a837.tar.gz -> gox-c9740af9c6574448fd48eb30a71f964014c7a837.tar.gz
	https://github.com/mitchellh/iochan/archive/87b45ffd0e9581375c491fef3d32130bb15c5bd7.tar.gz -> iochan-87b45ffd0e9581375c491fef3d32130bb15c5bd7.tar.gz
"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

get_archive_go_package() {
	local archive=${1} uri x
	for x in ${SRC_URI}; do
		if [[ ${x} == http* ]]; then
			uri=${x}
		elif [[ ${x} == ${archive} ]]; then
			break
		fi
	done
	uri=${uri#https://}
	echo ${uri%/archive/*}
}

unpack_go_packages() {
	local go_package x
	# Unpack packages to appropriate locations for GOPATH
	for x in ${A}; do
		unpack ${x}
		if [[ ${x} == *.tar.gz ]]; then
			go_package=$(get_archive_go_package ${x})
			mkdir -p src/${go_package%/*}
			mv ${go_package##*/}-* src/${go_package} || die
		fi
	done
}

src_unpack() {
	mkdir "${S}" && cd "${S}" || die
	unpack_go_packages
}

src_prepare() {
	eapply_user
	# Avoid the need to have a git checkout
	sed -e 's:^GIT.*::' -i src/${EGO_PN%/*}/scripts/build.sh || die
}

src_compile() {
	export GOPATH=${S}
	go install -v -work -x ${EGO_BUILD_FLAGS} "github.com/mitchellh/gox/..." || die
	cd "${S}"/src/${EGO_PN%/*} || die
	PATH=${PATH}:${S}/bin \
	XC_ARCH=$(go env GOARCH) \
	XC_OS=$(go env GOOS) \
	emake bin
}

src_test() {
	cd "${S}"/src/${EGO_PN%/*} || die
	emake test || die
}

src_install() {
	dobin "${S}/bin/${PN}"
	dodoc "${S}"/src/${EGO_PN%/*}/{CHANGELOG.md,README.md}

	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"

	keepdir /etc/${PN}.d
	insinto /etc/${PN}.d
	doins "${FILESDIR}/"*.json.example
}
