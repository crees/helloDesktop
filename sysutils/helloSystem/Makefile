PORTNAME=	helloSystem
PORTVERSION=	0.8.1
DISTVERSIONPREFIX=	r
CATEGORIES=	sysutils

MAINTAINER=	crees@FreeBSD.org
COMMENT=	Supporting components for Hello System

LICENSE=	BSD3CLAUSE

USES=		desktop-file-utils
USE_GITHUB=	yes
GH_ACCOUNT=	helloSystem
GH_PROJECT=	ISO
NO_BUILD=	yes
WRKSRC_SUBDIR=	overlays/uzip/hello/files

post-patch:
.for f in etc/gtk-3.0/settings.ini etc/slim.conf etc/chrome/policies/managed/privacy.json
	${MV} ${WRKSRC}/usr/local/$f ${WRKSRC}/usr/local/$f.hello
.endfor
	${RM} ${WRKSRC}/.hidden
	${MV} ${WRKSRC}/usr/local ${WRKSRC}/../_prefix

do-install:
	${MKDIR} ${STAGEDIR}${PREFIX}
	(cd ${INSTALL_WRKSRC} && \
		${COPYTREE_SHARE} \. ${STAGEDIR} '-not -name .gitkeep')
	(cd ${INSTALL_WRKSRC}/../_prefix && \
		${COPYTREE_SHARE} \. ${STAGEDIR}${PREFIX})

.include <bsd.port.mk>
