# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_PN="tesseract-ocr"
URI_PREFIX="https://github.com/${MY_PN}/tessdata/raw/${PV}/"

inherit eutils autotools autotools-utils

DESCRIPTION="An OCR Engine, orginally developed at HP, now open source."
HOMEPAGE="https://github.com/tesseract-ocr"
SRC_URI="https://github.com/${MY_PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	${URI_PREFIX}eng.traineddata -> eng.traineddata-${PV}
	doc? ( https://tesseract-ocr.googlecode.com/files/tesseract-ocr-3.02.02-doc-html.tar.gz )
	l10n_ar? ( ${URI_PREFIX}ara.traineddata -> ara.traineddata-${PV} )
	l10n_bg? ( ${URI_PREFIX}bul.traineddata -> bul.traineddata-${PV} )
	l10n_ca? ( ${URI_PREFIX}cat.traineddata -> cat.traineddata-${PV} )
	l10n_chr? ( ${URI_PREFIX}chr.traineddata -> chr.traineddata-${PV} )
	l10n_cs? ( ${URI_PREFIX}ces.traineddata -> ces.traineddata-${PV} )
	l10n_de? ( ${URI_PREFIX}deu.traineddata -> deu.traineddata-${PV}
			   ${URI_PREFIX}deu_frak.traineddata -> deu_frak.traineddata-${PV} )
	l10n_da? ( ${URI_PREFIX}dan.traineddata -> dan.traineddata-${PV}
			   ${URI_PREFIX}dan_frak.traineddata -> dan_frak.traineddata-${PV} )
	l10n_el? ( ${URI_PREFIX}ell.traineddata -> ell.traineddata-${PV} )
	l10n_es? ( ${URI_PREFIX}spa.traineddata -> spa.traineddata-${PV} )
	l10n_fi? ( ${URI_PREFIX}fin.traineddata -> fin.traineddata-${PV} )
	l10n_fr? ( ${URI_PREFIX}fra.traineddata -> fra.traineddata-${PV} )
	l10n_he? ( ${URI_PREFIX}heb.traineddata -> heb.traineddata-${PV} )
	l10n_hi? ( ${URI_PREFIX}hin.traineddata -> hin.traineddata-${PV} )
	l10n_hu? ( ${URI_PREFIX}hun.traineddata -> hun.traineddata-${PV} )
	l10n_id? ( ${URI_PREFIX}ind.traineddata -> ind.traineddata-${PV} )
	l10n_it? ( ${URI_PREFIX}ita.traineddata -> ita.traineddata-${PV} )
	l10n_ja? ( ${URI_PREFIX}jpn.traineddata -> jpn.traineddata-${PV} )
	l10n_ko? ( ${URI_PREFIX}kor.traineddata -> kor.traineddata-${PV} )
	l10n_lt? ( ${URI_PREFIX}lit.traineddata -> lit.traineddata-${PV} )
	l10n_lv? ( ${URI_PREFIX}lav.traineddata -> lav.traineddata-${PV} )
	l10n_nl? ( ${URI_PREFIX}nld.traineddata -> nld.traineddata-${PV} )
	l10n_no? ( ${URI_PREFIX}nor.traineddata -> nor.traineddata-${PV} )
	l10n_pl? ( ${URI_PREFIX}pol.traineddata -> pol.traineddata-${PV} )
	l10n_pt? ( ${URI_PREFIX}por.traineddata -> por.traineddata-${PV} )
	l10n_ro? ( ${URI_PREFIX}ron.traineddata -> ron.traineddata-${PV} )
	l10n_ru? ( ${URI_PREFIX}rus.traineddata -> rus.traineddata-${PV} )
	l10n_sk? ( ${URI_PREFIX}slk.traineddata -> slk.traineddata-${PV}
			   ${URI_PREFIX}slk_frak.traineddata -> slk_frak.traineddata-${PV} )
	l10n_sl? ( ${URI_PREFIX}slv.traineddata -> slv.traineddata-${PV} )
	l10n_sr? ( ${URI_PREFIX}srp.traineddata -> srp.traineddata-${PV} )
	l10n_sv? ( ${URI_PREFIX}swe.traineddata -> swe.traineddata-${PV} )
	l10n_th? ( ${URI_PREFIX}tha.traineddata -> tha.traineddata-${PV} )
	l10n_tl? ( ${URI_PREFIX}tgl.traineddata -> tgl.traineddata-${PV} )
	l10n_tr? ( ${URI_PREFIX}tur.traineddata -> tur.traineddata-${PV} )
	l10n_uk? ( ${URI_PREFIX}ukr.traineddata -> ukr.traineddata-${PV} )
	l10n_vi? ( ${URI_PREFIX}vie.traineddata -> vie.traineddata-${PV} )
	l10n_zh-CN? ( ${URI_PREFIX}chi_sim.traineddata -> chi_sim.traineddata-${PV} )
	l10n_zh-TW? ( ${URI_PREFIX}chi_tra.traineddata -> chi_tra.traineddata-${PV} )
	osd? ( ${URI_PREFIX}osd.traineddata -> osd.traineddata-${PV} )
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~mips ppc ppc64 sparc x86"

IUSE="doc examples jpeg opencl osd png +scrollview static-libs tiff training -webp l10n_ar l10n_bg l10n_ca l10n_chr l10n_cs l10n_de l10n_da l10n_el l10n_es l10n_fi l10n_fr l10n_he l10n_hi l10n_hu l10n_id l10n_it l10n_ja l10n_ko l10n_lt l10n_lv l10n_nl l10n_no l10n_pl l10n_pt l10n_ro l10n_ru l10n_sk l10n_sl l10n_sr l10n_sv l10n_th l10n_tl l10n_tr l10n_uk l10n_vi l10n_zh-CN l10n_zh-TW"

# With opencl USE=tiff is necessary in leptonica
DEPEND=">=media-libs/leptonica-1.71[zlib,tiff?,jpeg?,png?,webp?]
		opencl? ( virtual/opencl
				  media-libs/tiff:0
				  >=media-libs/leptonica-1.71[zlib,tiff,jpeg?,png?,webp?]
				)
	training? (
	  dev-libs/icu
	  x11-libs/pango
	  x11-libs/cairo
	)
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README ReleaseNotes )

PATCHES=(
	"${FILESDIR}/tesseract-2.04-gcc47.patch"
	"${FILESDIR}/${P}-fix-scrollview-disabled.patch"
)

src_unpack() {
	unpack ${P}.tar.gz
	use doc && unpack tesseract-ocr-3.02.02-doc-html.tar.gz
	find "${DISTDIR}/" -name "*traineddata-${PV}" \
		 -execdir sh -c 'cp -- "$0" "${S}/tessdata/${0%-*}"' '{}' ';' || die
}

src_configure() {
	local myeconfargs=(
		$(use_enable opencl) \
		$(use_enable scrollview graphics)
		)
	autotools-utils_src_configure
}

src_compile() {
	default
	if use training; then
		emake training
	fi
	}

src_install() {
	autotools-utils_src_install

	if use training; then
		pushd "${BUILD_DIR}"
		emake DESTDIR="${D}" training-install
		popd
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins testing/eurotext.tif testing/phototest.tif
	fi

	if use doc; then
		dohtml -r "${WORKDIR}"/"${MY_PN}"/doc/html/*
	fi

	# install language files
	insinto /usr/share/tessdata
	doins "${S}"/tessdata/*traineddata*
}
