<!DOCTYPE html><html lang="en" style="" data-color-mode="system" class=" useReactApp  "><head><meta charset="utf-8"><meta name="readme-deploy" content="5.715.0"><meta name="readme-subdomain" content="og-restrpc"><meta name="readme-repo" content="og-restrpc-e94feaf3d870"><meta name="readme-project-flags" content="qaTFUBGQxv9BWHP+yUUytQ==:BU+gira7M0aniko/7YQO3MxhdJgO3AwlxI4F0A0zE1esb+OiIOJV56pkR0Dg7bjZf4jehIQNrmAnLHmRBM+dCVHr1TKEQwm6WEY2PosJl7bwuVc4V2cR0gBiRt2MeSjVr6Mv520PNd7Ri31ZzYGqlLRIqmaOyAB+htQoH70O2CeskUocEZc2tk8lvJ1Dbdic"><meta name="readme-version" content="2.10.0"><title>Orders</title><meta name="description" content="" data-rh="true"><meta property="og:title" content="Orders" data-rh="true"><meta property="og:description" content="" data-rh="true"><meta property="og:site_name" content="Ordergroove API Reference"><meta name="twitter:title" content="Orders" data-rh="true"><meta name="twitter:description" content="" data-rh="true"><meta name="twitter:card" content="summary_large_image"><meta name="viewport" content="width=device-width, initial-scale=1.0"><meta property="og:image:width" content="1200"><meta property="og:image:height" content="630"><link id="favicon" rel="shortcut icon" href="https://files.readme.io/ee510bc0f7c463612c51d58e576398fdb238ce0348a94eafa28cc22d29e08a0f-favicon.png" type="image/png"><link rel="canonical" href="https://developer.ordergroove.com/page/graphql-orders"><script src="https://cdn.readme.io/public/js/cash-dom.min.js?1778099638423"></script><link data-chunk="Footer" rel="preload" as="style" href="https://cdn.readme.io/public/hub/web/Footer.7ca87f1efe735da787ba.css">
<link data-chunk="RDMD" rel="preload" as="style" href="https://cdn.readme.io/public/hub/web/RDMD.7fcd74ba721857187cfa.css">
<link data-chunk="RDMD" rel="preload" as="style" href="https://cdn.readme.io/public/hub/web/8788.148064913c96b6b89e85.css">
<link data-chunk="CustomPage" rel="preload" as="style" href="https://cdn.readme.io/public/hub/web/CustomPage.2bf6bc5416af3fb0f386.css">
<link data-chunk="Header" rel="preload" as="style" href="https://cdn.readme.io/public/hub/web/Header.4d02fb2e4751cb575d4f.css">
<link data-chunk="Header" rel="preload" as="style" href="https://cdn.readme.io/public/hub/web/ui-styles.fd5cdb08999d46511fd4.css">
<link data-chunk="Containers-EndUserContainer" rel="preload" as="style" href="https://cdn.readme.io/public/hub/web/Containers-EndUserContainer.695e20cfe81a7d276d6e.css">
<link data-chunk="main" rel="preload" as="style" href="https://cdn.readme.io/public/hub/web/main.856dcf51e5fa573ce1d2.css">
<link data-chunk="main" rel="preload" as="script" href="https://cdn.readme.io/public/hub/web/main.cbffc40ba4cf9166e585.js">
<link data-chunk="routes-SuperHub" rel="preload" as="script" href="https://cdn.readme.io/public/hub/web/routes-SuperHub.0bc764dff71f3d0333ac.js">
<link data-chunk="Containers-EndUserContainer" rel="preload" as="script" href="https://cdn.readme.io/public/hub/web/Containers-EndUserContainer.01e921597f816edd7e87.js">
<link data-chunk="Header" rel="preload" as="script" href="https://cdn.readme.io/public/hub/web/7154.1c8f05e443c98afc7a0f.js">
<link data-chunk="Header" rel="preload" as="script" href="https://cdn.readme.io/public/hub/web/7783.e3a96d2d4e2c0cf1ee32.js">
<link data-chunk="Header" rel="preload" as="script" href="https://cdn.readme.io/public/hub/web/Header.a4a4a6e16e106134b124.js">
<link data-chunk="routes-SuperHub-Routes" rel="preload" as="script" href="https://cdn.readme.io/public/hub/web/routes-SuperHub-Routes.f72c8d8d47efc314c741.js">
<link data-chunk="CustomPage" rel="preload" as="script" href="https://cdn.readme.io/public/hub/web/3760.5a51af39357427d3c55f.js">
<link data-chunk="CustomPage" rel="preload" as="script" href="https://cdn.readme.io/public/hub/web/CustomPage.5116ddec2abe493c18cd.js">
<link data-chunk="ConnectMetadata" rel="preload" as="script" href="https://cdn.readme.io/public/hub/web/ConnectMetadata.7acf3bac8b27bf379d05.js">
<link data-chunk="RDMD" rel="preload" as="script" href="https://cdn.readme.io/public/hub/web/2759.fcb8db7f411e07138d64.js">
<link data-chunk="RDMD" rel="preload" as="script" href="https://cdn.readme.io/public/hub/web/6123.3cf2d759650e72709b6b.js">
<link data-chunk="RDMD" rel="preload" as="script" href="https://cdn.readme.io/public/hub/web/6328.cf13ec042f3090c9cff5.js">
<link data-chunk="RDMD" rel="preload" as="script" href="https://cdn.readme.io/public/hub/web/6146.cb8f37a2ef0ab72d4bf7.js">
<link data-chunk="RDMD" rel="preload" as="script" href="https://cdn.readme.io/public/hub/web/9503.36898a7a11ea5cc38308.js">
<link data-chunk="RDMD" rel="preload" as="script" href="https://cdn.readme.io/public/hub/web/5492.ff4a6bd49595b926b88b.js">
<link data-chunk="RDMD" rel="preload" as="script" href="https://cdn.readme.io/public/hub/web/8804.be101e35a551c64842f5.js">
<link data-chunk="RDMD" rel="preload" as="script" href="https://cdn.readme.io/public/hub/web/6479.e42542b9e97772ee967e.js">
<link data-chunk="RDMD" rel="preload" as="script" href="https://cdn.readme.io/public/hub/web/8850.e583937352ffa8a54ec1.js">
<link data-chunk="RDMD" rel="preload" as="script" href="https://cdn.readme.io/public/hub/web/8735.929987ccecda48e3c68e.js">
<link data-chunk="RDMD" rel="preload" as="script" href="https://cdn.readme.io/public/hub/web/8788.3c071cd2380b8d501415.js">
<link data-chunk="RDMD" rel="preload" as="script" href="https://cdn.readme.io/public/hub/web/RDMD.b4750a9d7f03279fe61a.js">
<link data-chunk="Footer" rel="preload" as="script" href="https://cdn.readme.io/public/hub/web/Footer.9f298ad202e3e5a56dd5.js">
<link data-chunk="main" rel="stylesheet" href="https://cdn.readme.io/public/hub/web/main.856dcf51e5fa573ce1d2.css">
<link data-chunk="Containers-EndUserContainer" rel="stylesheet" href="https://cdn.readme.io/public/hub/web/Containers-EndUserContainer.695e20cfe81a7d276d6e.css">
<link data-chunk="Header" rel="stylesheet" href="https://cdn.readme.io/public/hub/web/ui-styles.fd5cdb08999d46511fd4.css">
<link data-chunk="Header" rel="stylesheet" href="https://cdn.readme.io/public/hub/web/Header.4d02fb2e4751cb575d4f.css">
<link data-chunk="CustomPage" rel="stylesheet" href="https://cdn.readme.io/public/hub/web/CustomPage.2bf6bc5416af3fb0f386.css">
<link data-chunk="RDMD" rel="stylesheet" href="https://cdn.readme.io/public/hub/web/8788.148064913c96b6b89e85.css">
<link data-chunk="RDMD" rel="stylesheet" href="https://cdn.readme.io/public/hub/web/RDMD.7fcd74ba721857187cfa.css">
<link data-chunk="Footer" rel="stylesheet" href="https://cdn.readme.io/public/hub/web/Footer.7ca87f1efe735da787ba.css"><!-- CUSTOM CSS--><style title="rm-custom-css">:root{--project-color-primary:#493e90;--project-color-inverse:#fff;--recipe-button-color:#219050;--recipe-button-color-hover:#0e3d22;--recipe-button-color-active:#04140b;--recipe-button-color-focus:rgba(33, 144, 80, 0.25);--recipe-button-color-disabled:#96e7b8}[id=enterprise] .ReadMeUI[is=AlgoliaSearch]{--project-color-primary:#493e90;--project-color-inverse:#fff}a{color:var(--color-link-primary,#219050)}a:hover{color:var(--color-link-primary-darken-5,#0e3d22)}a.text-muted:hover{color:var(--color-link-primary,#219050)}.btn.btn-primary{background-color:#219050}.btn.btn-primary:hover{background-color:#0e3d22}.theme-line #hub-landing-top h2{color:#219050}#hub-landing-top .btn:hover{color:#219050}.theme-line #hub-landing-top .btn:hover{color:#fff}.theme-solid header#hub-header #header-top{background-color:#493e90}.theme-solid.header-gradient header#hub-header #header-top{background:linear-gradient(to bottom,#493e90,#271d64)}.theme-solid.header-custom header#hub-header #header-top{background-image:url("undefined")}.theme-line header#hub-header #header-top{border-bottom-color:#493e90}.theme-line header#hub-header #header-top .btn{background-color:#493e90}header#hub-header #header-top #header-logo{width:118px;height:40px;margin-top:0;background-image:url("https://files.readme.io/6fdeecee3b160d06768dc696c4c0fe8ebd672b51f1e65e1e54e375a42893c599-short_white_bg.png")}#hub-subheader-parent #hub-subheader .hub-subheader-breadcrumbs .dropdown-menu a:hover{background-color:#493e90}#subheader-links a.active{color:#493e90!important;box-shadow:inset 0 -2px 0 #493e90}#subheader-links a:hover{color:#493e90!important;box-shadow:inset 0 -2px 0 #493e90;opacity:.7}.discussion .submit-vote.submit-vote-parent.voted a.submit-vote-button{background-color:#219050}section#hub-discuss .discussion a .discuss-body h4{color:#219050}section#hub-discuss .discussion a:hover .discuss-body h4{color:#0e3d22}#hub-subheader-parent #hub-subheader.sticky-header.sticky{border-bottom-color:#219050}#hub-subheader-parent #hub-subheader.sticky-header.sticky .search-box{border-bottom-color:#219050}#hub-search-results h3 em{color:#219050}.main_background,.tag-item{background:#219050!important}.main_background:hover{background:#0e3d22!important}.main_color{color:#493e90!important}.border_bottom_main_color{border-bottom:2px solid #493e90}.main_color_hover:hover{color:#493e90!important}section#hub-discuss h1{color:#219050}#hub-reference .hub-api .api-definition .api-try-it-out.active{border-color:#219050;background-color:#219050}#hub-reference .hub-api .api-definition .api-try-it-out.active:hover{background-color:#0e3d22;border-color:#0e3d22}#hub-reference .hub-api .api-definition .api-try-it-out:hover{border-color:#219050;color:#219050}#hub-reference .hub-reference .logs .logs-empty .logs-login-button,#hub-reference .hub-reference .logs .logs-login .logs-login-button{background-color:var(--project-color-primary,#219050);border-color:var(--project-color-primary,#219050)}#hub-reference .hub-reference .logs .logs-empty .logs-login-button:hover,#hub-reference .hub-reference .logs .logs-login .logs-login-button:hover{background-color:#0e3d22;border-color:#0e3d22}#hub-reference .hub-reference .logs .logs-empty>svg>path,#hub-reference .hub-reference .logs .logs-login>svg>path{fill:#219050;fill:var(--project-color-primary,#219050)}#hub-reference .hub-reference .logs:last-child .logs-empty,#hub-reference .hub-reference .logs:last-child .logs-login{margin-bottom:35px}#hub-reference .hub-reference .hub-reference-section .hub-reference-left header .hub-reference-edit:hover{color:#219050}.main-color-accent{border-bottom:3px solid #493e90;padding-bottom:8px}/*! BEGIN HUB_CUSTOM_STYLES */@font-face{font-family:Inter;src:url("https://use.typekit.net/af/59b013/00000000000000007735a1aa/30/l?primer=7cdcb44be4a7db8877ffa5c0007b8dd865b3bbc383831fe2ea177f62257a9191&fvd=n5&v=3") format("woff2"),url("https://use.typekit.net/af/59b013/00000000000000007735a1aa/30/d?primer=7cdcb44be4a7db8877ffa5c0007b8dd865b3bbc383831fe2ea177f62257a9191&fvd=n5&v=3") format("woff"),url("https://use.typekit.net/af/59b013/00000000000000007735a1aa/30/a?primer=7cdcb44be4a7db8877ffa5c0007b8dd865b3bbc383831fe2ea177f62257a9191&fvd=n5&v=3") format("opentype");font-display:auto;font-style:normal;font-weight:500;font-stretch:normal}@font-face{font-family:InterSemibold;src:url("https://use.typekit.net/af/3ec29d/00000000000000007735a1b1/30/l?primer=7cdcb44be4a7db8877ffa5c0007b8dd865b3bbc383831fe2ea177f62257a9191&fvd=n4&v=3") format("woff2"),url("https://use.typekit.net/af/3ec29d/00000000000000007735a1b1/30/d?primer=7cdcb44be4a7db8877ffa5c0007b8dd865b3bbc383831fe2ea177f62257a9191&fvd=n4&v=3") format("woff"),url("https://use.typekit.net/af/3ec29d/00000000000000007735a1b1/30/a?primer=7cdcb44be4a7db8877ffa5c0007b8dd865b3bbc383831fe2ea177f62257a9191&fvd=n4&v=3") format("opentype");font-display:auto;font-style:normal;font-weight:400;font-stretch:normal}@font-face{font-family:InterSemibold;src:url("https://use.typekit.net/af/fd801b/00000000000000007735a1b6/30/l?primer=7cdcb44be4a7db8877ffa5c0007b8dd865b3bbc383831fe2ea177f62257a9191&fvd=n6&v=3") format("woff2"),url("https://use.typekit.net/af/fd801b/00000000000000007735a1b6/30/d?primer=7cdcb44be4a7db8877ffa5c0007b8dd865b3bbc383831fe2ea177f62257a9191&fvd=n6&v=3") format("woff"),url("https://use.typekit.net/af/fd801b/00000000000000007735a1b6/30/a?primer=7cdcb44be4a7db8877ffa5c0007b8dd865b3bbc383831fe2ea177f62257a9191&fvd=n6&v=3") format("opentype");font-display:auto;font-style:normal;font-weight:600;font-stretch:normal}@font-face{font-family:InterBold;src:url("https://use.typekit.net/af/5d2da8/00000000000000007735a1ac/30/l?primer=7cdcb44be4a7db8877ffa5c0007b8dd865b3bbc383831fe2ea177f62257a9191&fvd=n7&v=3") format("woff2"),url("https://use.typekit.net/af/5d2da8/00000000000000007735a1ac/30/d?primer=7cdcb44be4a7db8877ffa5c0007b8dd865b3bbc383831fe2ea177f62257a9191&fvd=n7&v=3") format("woff"),url("https://use.typekit.net/af/5d2da8/00000000000000007735a1ac/30/a?primer=7cdcb44be4a7db8877ffa5c0007b8dd865b3bbc383831fe2ea177f62257a9191&fvd=n7&v=3") format("opentype");font-display:auto;font-style:normal;font-weight:700;font-stretch:normal}.hub-is-home .rm-Header{display:none!important}*{margin:0;padding:0;box-sizing:border-box}#ssr-main>div>div.SuperHub2RNxzk6HzHiJ>div>div.ContentWithOwlbot-content2X1XexaN8Lf2>header>div.Header-bottom2eLKOFXMEmh5.Header-bottom_compact.rm-Header-bottom.Header-bottom_withOwlbot3wuKp8NLXCqs>div>nav>a:nth-child(6)>span,#ssr-main>div>div.SuperHub2RNxzk6HzHiJ>div>div.ContentWithOwlbot-content2X1XexaN8Lf2>header>div.Header-bottom2eLKOFXMEmh5.Header-bottom_compact.rm-Header-bottom.Header-bottom_withOwlbot3wuKp8NLXCqs>div>nav>a:nth-child(7)>span{position:relative;padding-right:20px}header div>nav>a[href^="https://"]>span::before{content:' ';position:absolute;display:block;right:0;top:2px;background-image:url("data:image/svg+xml,<svg width='16' height='16' viewBox='0 0 16 16' fill='none' xmlns='http://www.w3.org/2000/svg'><path d='M7.25 2H4.25C3.00736 2 2 3.00735 2 4.24999V11.75C2 12.9926 3.00736 14 4.25 14H11.75C12.9926 14 14 12.9926 14 11.75V8.74996M10.2496 2.00018L14 2M14 2V5.37507M14 2L7.62445 8.37478' stroke-width='1.5' stroke-linecap='round' stroke='%2317132f' stroke-linejoin='round'/></svg>");height:16px;width:16px}[data-color-mode=dark] header div>nav>a:nth-child(6)>span::before,[data-color-mode=dark] header div>nav>a:nth-child(7)>span::before{background-image:url('data:image/svg+xml,<svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg"> <path d="M7.25 2H4.25C3.00736 2 2 3.00735 2 4.24999V11.75C2 12.9926 3.00736 14 4.25 14H11.75C12.9926 14 14 12.9926 14 11.75V8.74996M10.2496 2.00018L14 2M14 2V5.37507M14 2L7.62445 8.37478" stroke="white" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/> </svg>')}.rm-Sidebar-heading{font-size:14px!important;color:#17132f!important}.rm-Sidebar-link{color:#514e63!important}.rm-Sidebar-link.active{color:#188c48!important}[data-color-mode=dark] .rm-Sidebar-heading{color:#fff!important}[data-color-mode=dark] .rm-Sidebar-link{color:#c7c6cd!important}[data-color-mode=dark] .rm-Sidebar-link.active{color:#51e18d!important}[data-color-mode=dark] .rm-SearchToggle{background-color:#17132f!important}.alignleft{float:left;margin-right:15px}.alignright{float:right;margin-left:15px}.aligncenter{display:block;margin:0 auto 15px}a:focus{outline:0 solid}img{max-width:100%;height:auto}h1,h2,h3,h4,h5,h6{margin:0 0 15px;font-family:Inter,Roboto;margin-bottom:15px}body{color:#2d2d2d;font-weight:400;font-family:Inter,sans-serif;line-height:1.428}[data-color-mode=dark] body{background-color:#17132f}[data-color-mode=dark] header.rm-Header{background-color:#131024}.selector-for-some-widget{box-sizing:content-box}.card-btn a:hover,a.custom--btn:hover{text-decoration:none!important}a,button,input,textarea{outline:0!important}a,button{border:none;text-decoration:none}p{margin-bottom:15px}.section-padding{padding:80px 0}.rm-LandingPage{width:100%;min-width:100%;padding:0}.home-container{width:1200px;padding:0 15px;margin:0 auto}.header-wrapper{display:flex;align-items:center;justify-content:space-between}.header-left{width:40%}.header-right{width:60%}.logo a{display:inline-block}.logo a img{max-height:32px}.logo a{display:inline-block;line-height:1}.logo a img{max-height:32px}.header-menu ul{margin:0;padding:0;list-style:none;position:relative;top:-3px}.header-menu ul li{display:inline-block;margin-right:40px}.header-menu ul li a{display:inline-block;color:#fff;font-size:14px;letter-spacing:.3px;transition:.3s;font-family:Inter,Roboto}.header-menu ul li a:hover{color:#00ff85}.header-area{background:#17132f;position:absolute;left:0;top:0;width:100%;z-index:99;transition:.3s;padding:30px 0}.hero-area{background:#17132f;height:850px;display:flex;align-items:center;padding-top:90px;overflow:hidden;position:relative;z-index:1}.hero-wrapper{display:flex;align-items:center;justify-content:space-between}.hero__text h1{font-family:Inter,Roboto;font-size:65px;color:#fff;line-height:130%;letter-spacing:-2px;margin-bottom:20px}.hero__text{max-width:660px}.hero-left{width:60%}.hero-right{width:40%;text-align:right}.hero-right img{width:100%;position:relative;top:-30px}.gradient__text{display:inline-block;background:linear-gradient(to right top,#00fe8f,#00ffb4,#00ffd4,#00fdec,#01fafe);-webkit-background-clip:text;-webkit-text-fill-color:transparent}.hero__text p{font-size:21px;color:#fff;font-weight:400;line-height:150%}.hero__btn{margin-top:40px}.custom--btn{border:1px solid #00ff85;color:#000!important;text-decoration:none;display:inline-block;padding:11px 32px;border-radius:40px;font-size:18px;font-family:Inter,Roboto;line-height:101%;background:#00ff85;padding-top:14px;transition:.3s}.custom--btn:hover{background-color:transparent;color:#00ff85!important}.hero-shp{position:absolute;right:0;bottom:-78%;z-index:-1;width:1000px}img.hero-shp-2{position:absolute;left:0;width:65%;top:90px;z-index:-2}.brand-wrapper{display:flex;align-items:center;justify-content:space-between;gap:0 10px}.brand-item{max-height:95px;display:flex;align-items:center;justify-content:center;padding:5px 5px}.brand-area{background:#fff;padding:15px 0}.get-started-area{padding:90px 0;background:#f5fff9;position:relative}.area-title{margin-bottom:40px;text-align:center}.area-title h2{color:#000;font-size:38px;font-family:Inter,Roboto}.about-card{position:relative;padding:40px 30px;height:355px;display:flex;align-items:center;justify-content:center;text-align:center;border-radius:20px;z-index:1;box-shadow:0 16px 8px 0 rgba(23,19,47,.1);max-width:360px;margin:0 auto;transition:.3s}.about-card:before{position:absolute;left:50%;top:50%;content:'';z-index:-2;background:#fff;border-radius:19px;transform:translate(-50%,-50%);height:calc(100% - 5px);width:calc(100% - 5px)}.about-card:after{position:absolute;left:0;top:0;width:100%;height:100%;background-image:linear-gradient(to right bottom,#00faff,#00daff,#00b3ff,#007fff,#8500ff);content:'';border-radius:20px;z-index:-3}.icon-bg{position:absolute;left:0;height:100%;top:0;width:100%;z-index:-1}.icon-bg{position:absolute;left:0;height:100%;top:0;width:100%;z-index:-1}.icon-box{display:inline-flex;align-items:center;justify-content:center;width:82px;height:82px;margin-bottom:25px;z-index:1;position:relative;font-size:0px}.icon-box:before{content:""}.about-card-inner h2{font-size:28px;color:#2d2d2d;font-weight:600}.about-card-inner p{font-size:16px;color:#2d2d2d;min-height:72px}.card-btn a{display:inline-flex;justify-content:center;color:#8500ff;font-size:18px;text-decoration:none;align-items:center;font-family:Inter,Roboto;gap:0 10px}.card-wrapper{display:grid;grid-template-columns:repeat(3,calc(33.33% - 13px));gap:0 20px}.card-btn img{width:18px;position:relative;top:-1px}.subscription-area{padding:120px 0;position:relative}.subscription-wrapper{padding:40px;position:relative;border-radius:30px 0 30px 30px;position:relative;z-index:1;padding-right:0;display:flex;align-items:center;justify-content:space-between}.subscription-wrapper:after{position:absolute;left:0;top:0;width:calc(100% - 50px);background:#17132f;content:'';height:100%;z-index:-1;border-radius:30px 0 30px 30px}.subscription-content{padding-left:10px;width:60%}.subscription-thumb{text-align:right;width:40%}.subscription-thumb img{max-width:420px}.subscription-content h5{display:block;color:#00ff85;font-size:14px;text-transform:uppercase;letter-spacing:.3px}.subscription-content h2{color:#fff;line-height:125%;font-size:30px;font-family:Inter,Roboto}.subscription-content p{max-width:450px;color:#fff}.partner-btn{margin-top:30px}.gradient-text-two{display:inline-block;background-image:linear-gradient(to right,#19eba1,#00d4db,#00b4ff,#08f,#782bf6);-webkit-background-clip:text;-webkit-text-fill-color:transparent}@media (min-width:1200px) and (max-width:1449px){.hero-area{height:780px}img.hero-shp-2{width:60%;top:80px}.hero-shp{bottom:-82%;width:905px}}@media (min-width:1200px) and (max-width:1300px){.hero-area{height:760px}.hero-shp{bottom:-85%;width:880px;right:-50px}.home-container{width:1170px}}@media (min-width:992px) and (max-width:1200px){.home-container{width:100%}.subscription-thumb img{max-width:360px}.subscription-content{padding-left:15px}.subscription-wrapper{padding:32px 20px;padding-right:0}.custom--btn{font-size:16px}.brand-item img{max-height:60px}.hero-area{height:640px;padding-top:80px}.hero__text h1{font-size:55px;line-height:120%}.hero__text p{font-size:19px}.hero__btn{margin-top:35px}.logo a img{max-height:28px}.hero-shp{bottom:-78%;width:760px;right:-10%}.icon-box{width:75px;height:74px;margin-bottom:20px}.about-card{padding:28px 22px;height:320px;border-radius:16px;max-width:360px}.about-card:before{border-radius:17px}.about-card:after{border-radius:16px}.about-card-inner h2{font-size:24px}.about-card-inner p{font-size:15px}footer{padding-top:60px;padding-bottom:20px}}@media (min-width:768px) and (max-width:991px){.home-container{width:100%}.header-menu ul li{display:inline-block;margin-right:30px}.logo a img{max-height:25px}.logo{text-align:right}.subscription-thumb img{max-width:100%;width:100%}.subscription-content{padding-left:0;width:60%;padding-right:25px}.subscription-wrapper{padding:30px;padding-right:0}.subscription-content h2{font-size:22px}.subscription-content p{font-size:14px}.custom--btn{padding:10px 28px;border-radius:40px;font-size:15px;line-height:101%;padding-top:13px}.hero__text h1{font-size:45px}.hero__text p{font-size:16px}.hero__btn{margin-top:30px}.hero-area{height:550px;padding-top:70px}.hero-shp{right:-14%;bottom:-77%;width:600px}img.hero-shp-2{width:60%;top:77px}.about-card{padding:25px 15px;height:280px}.icon-box{width:64px;height:64px;margin-bottom:15px}.about-card-inner h2{font-size:20px;margin-bottom:10px}.about-card-inner p{font-size:14px}.card-btn a{font-size:15px;gap:0 8px}.area-title h2{font-size:30px}.icon-bg{position:absolute;left:0;height:100%;top:0;width:100%;z-index:-1}.icon-box img:first-child{width:36px}.subscription-area{padding:80px 0}.footer-logo img{max-height:28px}.subscription-box{height:38px}}@media only screen and (max-width:767px){.brand-wrapper{gap:20px 10px;flex-wrap:wrap}.brand-item{height:140px;padding:5px 5px;display:flex;align-items:center;justify-content:center;margin-bottom:20px}.card-wrapper{display:grid;grid-template-columns:repeat(1,calc(100%));gap:0 20px}.about-card{margin-bottom:25px}.footer-wrapper{display:block}.home-container{width:100%;padding:0 15px;margin:0 auto}.subscription-thumb img{max-width:100%}.subscription-thumb{display:none}.subscription-content{padding-left:0;width:100%}.subscription-wrapper:after{width:100%;height:100%;z-index:-1;border-radius:16px}.subscription-wrapper:after{border-radius:40px;padding:35px 25px}.subscription-content h2{font-size:20px}.subscription-content h2{color:#fff;font-size:20px;font-family:Inter}.logo a img{max-height:20px}.header-menu ul li{margin-right:12px}.header-menu ul li a{font-size:13px}.hero__text h1{font-size:28px}.hero-wrapper{display:block}.hero-left{width:100%}.hero-area{height:auto;padding-top:70px;padding-bottom:70px}.hero-wrapper{text-align:center}.hero-right img{width:320px;position:relative;top:0}.hero__text p{font-size:16px}.hero-right{width:100%;text-align:center;margin-top:50px}.hero-right img{width:200px;position:relative}.header-left{width:85%}.logo{text-align:right}.header-right{width:40%}.hero-wrapper{display:flex;flex-direction:column-reverse}.hero-left{margin-top:50px}.brand-item img{max-height:70px}.brand-wrapper{gap:0 10px;flex-wrap:wrap}.brand-item{padding:5px 5px;justify-content:center;margin-bottom:20px}.brand-item{padding:9px 5px;justify-content:center;margin-bottom:10px}.brand-item img{width:70px}.brand-item{height:69px;padding:5px 5px;margin-bottom:20px}.brand-item{height:60px}.get-started-area{padding:60px 0}.subscription-wrapper{padding:30px;z-index:1;padding-right:0;background:#000;border-radius:15px!important}.subscription-wrapper:after{border-radius:40px;width:100%}.subscription-area{padding:90px 0}.footer-left{width:100%;margin-bottom:35px}.footer-widget{width:100%}.footer-right{width:100%}.subscription-wrapper:after{display:none}.footer-right{width:100%;display:block}.footer-bottom-wrapper{display:block;text-align:center}.social-links{text-align:center;margin-top:25px}.social-links{display:flex;justify-content:center;align-items:center;margin-top:25px}.footer-logo{margin-bottom:15px;width:150px}.subscription-form{display:block}.footer-right{margin-top:50px}.subscription-wrapper{padding:30px;z-index:1;padding-right:0;background:#000;border-radius:15px!important}.area-title h2{font-size:28px}.custom--btn{padding-top:14px}.brand-item img{width:85px}}.home-footer{background:#17132f;padding-top:80px;padding-bottom:50px}.subscription-form label{color:#d8d7df;font-size:10px;margin-bottom:10px;font-family:Inter;letter-spacing:.3px}.subscription-box input{width:100%;height:100%;border-radius:40px;border:none;color:#666279;padding:8px 16px;line-height:1;font-size:12px;font-family:Inter}.subscription-box button{position:absolute;right:12px;top:50%;background:0 0;border:none;cursor:pointer;transform:translateY(-50%);padding:0;margin-top:-2px}.footer-left-content{max-width:220px}.footer-logo{margin-bottom:15px}.footer-left-content p{color:#aba9ba;font-size:12px;line-height:130%;font-family:Inter}.subscription-box{position:relative;width:220px;height:38px}.subscription-form label{color:#d8d7df;font-size:10px;margin-bottom:10px;font-family:Inter;letter-spacing:.3px;display:block}.footer-widget h3{font-size:14px;color:#fff;display:block;padding-bottom:10px;border-bottom:1px solid #4f4a6a;max-width:165px;margin-bottom:20px}.footer-links{margin-bottom:35px}.footer-links ul{margin:0;padding:0;list-style:none}.footer-links ul li{display:block;margin-bottom:7px;font-size:12px;color:#aba9ba}.footer-links ul li a{display:block;color:#aba9ba;text-decoration:none;font-size:12px;letter-spacing:.3px;transition:.3s;font-family:Inter}.footer-links li a:hover{color:#00ff85}.subtitle h4{font-size:10px;color:#ebeaf0;text-transform:uppercase;font-family:Inter;margin-bottom:12px}.footer-left{width:32%}.footer-right{width:68%;display:flex;gap:0 15px}.footer-wrapper{display:flex;justify-content:space-between;align-items:flex-start}.footer-widget{width:33.33%}.copyright-text p{color:#787688;font-size:12px;letter-spacing:.2px;margin:0;font-family:Inter}.social-links{display:flex;justify-content:flex-end;align-items:center}.social-links ul{margin:0;padding:0;list-style:none}.social-links ul li{display:inline-block;margin-left:10px}.social-links ul li a{display:inline-flex;width:33px;height:33px;background:#2e2a47;align-items:center;justify-content:center;border-radius:100%;transition:.3s;border:1px solid #2e2a47}.footer-bottom-wrapper{padding-top:25px;padding-bottom:10px;border-top:1px solid #2e2a47;display:flex;align-items:center;justify-content:space-between;gap:0 15px}.subscription-box button{position:absolute;right:12px;top:50%;background:0 0;border:none;cursor:pointer;transform:translateY(-50%);padding:0;margin-top:2px}.markdown-body pre>code{white-space:pre!important;overflow-x:auto!important;word-break:normal!important;word-wrap:normal!important}.rdmd-table td,.rdmd-table th{white-space:nowrap!important;padding:12px 15px}.rdmd-table-inner{overflow-x:auto!important;display:block;width:100%}.rm-CustomPage>div:has(.gql-docs){width:100vw;padding:0 40px;box-sizing:border-box}.gql-docs{--gql-border:#e1e3e5;--gql-text:#1a1a1a;--gql-text-muted:#616161;--gql-text-link:#0057b8;--gql-accent:#008060;--gql-badge-required:#d72c0d;--gql-badge-bg-required:#fef0ee;--gql-font-mono:'SF Mono',SFMono-Regular,Consolas,'Liberation Mono',Menlo,monospace;line-height:1.6;width:100vw;margin-left:calc(-50vw + 50%);padding:0 40px;box-sizing:border-box}.gql-docs h1 code{font-family:var(--gql-font-mono);font-weight:600;background:0 0;padding:0}.gql-docs .gql-subtitle{font-size:15px;color:var(--gql-text-muted);margin-bottom:24px}.gql-docs .gql-description{font-size:15px;line-height:1.7;margin-bottom:24px}.gql-docs .gql-description ul{margin:12px 0;padding-left:24px}.gql-docs .gql-description li{margin-bottom:4px}.gql-docs .gql-callout{background:#f6f6f7;border-left:3px solid var(--gql-accent);border-radius:4px;padding:12px 16px;font-size:14px;margin-bottom:24px;color:var(--gql-text-muted)}.gql-docs .gql-section-heading{font-size:20px;font-weight:600;margin-top:40px;margin-bottom:16px;padding-bottom:8px;border-bottom:1px solid var(--gql-border)}.gql-docs .gql-arg-list{list-style:none;margin:0;padding:0}.gql-docs .gql-arg-item{padding:12px 0;border-bottom:1px solid var(--gql-border)}.gql-docs .gql-arg-item:last-child{border-bottom:none}.gql-docs .gql-arg-header{display:flex;align-items:center;gap:8px;margin-bottom:4px}.gql-docs .gql-arg-name{font-family:var(--gql-font-mono);font-size:14px;font-weight:600;color:var(--gql-text)}.gql-docs .gql-type-tag{font-family:var(--gql-font-mono);font-size:13px;color:var(--gql-text-link)}.gql-docs .gql-badge{font-size:11px;font-weight:600;padding:1px 6px;border-radius:3px;text-transform:uppercase;letter-spacing:.5px;display:inline-block}.gql-docs .gql-badge-required{color:var(--gql-badge-required);background:var(--gql-badge-bg-required)}.gql-docs .gql-badge-non-null{color:var(--gql-accent);background:#e3f4ef}.gql-docs .gql-arg-desc{font-size:14px;color:var(--gql-text-muted)}.gql-docs .gql-field-list{list-style:none;margin:0;padding:0}.gql-docs .gql-field-item{border-bottom:1px solid var(--gql-border)}.gql-docs .gql-field-row{display:flex;align-items:baseline;gap:8px;padding:10px 0;flex-wrap:wrap}.gql-docs .gql-field-name{font-family:var(--gql-font-mono);font-size:14px;font-weight:600;color:var(--gql-text)}.gql-docs .gql-field-desc{font-size:13px;color:var(--gql-text-muted);flex-basis:100%;margin-top:2px}.gql-docs details.gql-nested-type{border-bottom:1px solid var(--gql-border)}.gql-docs details.gql-nested-type>summary{display:flex;align-items:center;gap:8px;padding:10px 0;cursor:pointer;list-style:none;flex-wrap:wrap}.gql-docs details.gql-nested-type>summary::-webkit-details-marker{display:none}.gql-docs details.gql-nested-type>summary::before{content:'\25B8';font-size:12px;color:var(--gql-text-muted);transition:transform .15s;flex-shrink:0}.gql-docs details.gql-nested-type[open]>summary::before{transform:rotate(90deg)}.gql-docs details.gql-nested-type>.gql-nested-content{padding:0 0 8px 20px;border-left:2px solid var(--gql-border);margin-left:4px;margin-bottom:8px}.gql-docs .gql-nested-type-heading{font-size:13px;font-weight:600;color:var(--gql-text-muted);text-transform:uppercase;letter-spacing:.5px;margin-bottom:4px;padding-top:4px}.gql-docs .gql-show-fields{font-size:12px;color:var(--gql-text-link);margin-left:auto}.gql-docs details.gql-nested-type[open]>summary .gql-show-fields{display:none}.gql-docs .gql-nav{width:200px;flex-shrink:0}.gql-docs .gql-nav-inner{position:sticky;top:20px}.gql-docs .gql-nav-section{border:none}.gql-docs .gql-nav-section>summary{font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:.8px;color:var(--gql-text-muted);padding:6px 0;cursor:pointer;list-style:none}.gql-docs .gql-nav-section>summary::-webkit-details-marker{display:none}.gql-docs .gql-nav-list{list-style:none;margin:0;padding:0}.gql-docs .gql-nav-link{display:block;font-family:var(--gql-font-mono);font-size:13px;padding:5px 12px;color:var(--gql-text-muted);text-decoration:none;border-radius:4px}.gql-docs a.gql-nav-link:hover{color:var(--gql-text);background:#f6f6f7}.gql-docs .gql-nav-active{color:var(--gql-text);font-weight:600;background:#f0f0f0}.gql-docs .gql-layout{display:flex;gap:32px;align-items:flex-start}.gql-docs .gql-main{flex:1;min-width:0}.gql-docs .gql-sidebar{width:380px;flex-shrink:0;min-width:0}.gql-docs .gql-sidebar-inner{position:sticky;top:20px;max-height:90vh;overflow-y:auto}.gql-docs .gql-sidebar-label{font-size:12px;font-weight:600;color:#a0a0a0;text-transform:uppercase;letter-spacing:.8px;padding:10px 16px 0;background:#1e1e1e;border-radius:6px 6px 0 0}.gql-docs .gql-sidebar-label:nth-of-type(n+2){margin-top:16px}@media (max-width:900px){.gql-docs .gql-nav{display:none}.gql-docs .gql-sidebar{display:none}.gql-docs .gql-layout{display:block}}.gql-docs pre{background:#1e1e1e;color:#d4d4d4;border-radius:0 0 6px 6px;padding:16px 20px;font-family:var(--gql-font-mono);font-size:13px;line-height:1.5;overflow-x:auto;margin-top:0;margin-bottom:0}.gql-docs pre.gql-code-standalone{border-radius:6px}.gql-docs pre .kw{color:#569cd6}.gql-docs pre .fl{color:#9cdcfe}.gql-docs pre .st{color:#ce9178}.gql-docs pre .vr{color:#dcdcaa}.gql-docs pre .cm{color:#6a9955}.gql-docs pre .nu{color:#b5cea8}.gql-docs pre .br{color:grey}.gql-docs .gql-response-label{font-size:12px;font-weight:600;color:#a0a0a0;text-transform:uppercase;letter-spacing:.8px;padding:12px 16px 0;background:#1e1e1e;margin-top:2px}.gql-docs .gql-examples{margin-bottom:24px}.gql-docs .gql-example-header{font-size:14px;font-weight:600;color:var(--gql-text);margin-bottom:8px}.gql-docs .gql-example-desc{font-size:13px;color:var(--gql-text-muted);margin:0 0 8px}.gql-docs .gql-ex-select{display:none}.gql-docs .gql-ex-select-label{display:inline-block;padding:4px 10px;font-size:12px;font-weight:600;cursor:pointer;color:var(--gql-text-muted);background:#f0f0f0;border:1px solid var(--gql-border);border-radius:12px;margin:0 4px 8px 0;transition:all .15s}.gql-docs .gql-ex-select:checked+.gql-ex-select-label{color:#fff;background:var(--gql-accent);border-color:var(--gql-accent)}.gql-docs .gql-examples>.gql-example{display:none}.gql-docs .gql-examples>input.gql-ex-select:first-of-type:checked~.gql-example:nth-of-type(1){display:block}.gql-docs .gql-examples>input.gql-ex-select:nth-of-type(2):checked~.gql-example:nth-of-type(2){display:block}.gql-docs .gql-examples>input.gql-ex-select:nth-of-type(3):checked~.gql-example:nth-of-type(3){display:block}.gql-docs .gql-examples>input.gql-ex-select:nth-of-type(4):checked~.gql-example:nth-of-type(4){display:block}.gql-docs .gql-example-tabs{border-radius:6px;overflow:hidden}.gql-docs .gql-example-tabs input[type=radio]{display:none}.gql-docs .gql-example-tabs label{display:inline-block;padding:6px 12px;font-size:12px;font-weight:600;cursor:pointer;color:#a0a0a0;background:#1e1e1e;border-bottom:2px solid transparent;margin:0}.gql-docs .gql-example-tabs input[type=radio]:checked+label{color:#fff;border-bottom-color:#569cd6}.gql-docs .gql-example-panel{display:none}.gql-docs .gql-example-panel pre{border-radius:0 0 6px 6px;max-height:60vh;overflow-y:auto;scrollbar-width:thin;scrollbar-color:#555 #1e1e1e}.gql-docs .gql-example-panel pre::-webkit-scrollbar{width:6px}.gql-docs .gql-example-panel pre::-webkit-scrollbar-track{background:#1e1e1e}.gql-docs .gql-example-panel pre::-webkit-scrollbar-thumb{background:#555;border-radius:3px}.gql-docs pre code{display:block;color:inherit;background:0 0;padding:0;font-size:inherit;user-select:all}.gql-docs .gql-example-tabs input:first-of-type:checked~div:nth-of-type(1){display:block}.gql-docs .gql-example-tabs input:nth-of-type(2):checked~div:nth-of-type(2){display:block}.gql-docs .gql-example-tabs input:nth-of-type(3):checked~div:nth-of-type(3){display:block}.gql-docs .gql-example-tabs input:nth-of-type(4):checked~div:nth-of-type(4){display:block}.gql-docs .gql-crosslinks{margin-bottom:24px}.gql-docs .gql-crosslinks-heading{font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:.8px;color:var(--gql-text-muted);margin-bottom:12px}.gql-docs .gql-crosslinks-list{list-style:none;margin:0;padding:0}.gql-docs .gql-crosslinks-list li{padding:8px 0;border-bottom:1px solid var(--gql-border)}.gql-docs .gql-crosslinks-list li:last-child{border-bottom:none}.gql-docs .gql-crosslink{display:block;font-size:14px;font-weight:500;color:var(--gql-text-link);text-decoration:none}.gql-docs a.gql-crosslink:hover{text-decoration:underline}.gql-docs .gql-crosslink-query{display:block;font-family:var(--gql-font-mono);font-size:12px;color:var(--gql-text-muted);margin-top:2px}.gql-docs .gql-crosslink-details{margin-top:6px}.gql-docs .gql-crosslink-details summary{font-size:12px;font-weight:600;color:var(--gql-text-link);cursor:pointer}.gql-docs .gql-crosslink-details[open] summary{margin-bottom:8px}[data-color-mode=dark] .gql-docs{--gql-border:#333;--gql-text:#e0e0e0;--gql-text-muted:#999;--gql-text-link:#58a6ff;--gql-accent:#3fb980;--gql-badge-required:#f97583;--gql-badge-bg-required:#3d1a1e}[data-color-mode=dark] .gql-docs .gql-badge-non-null{background:#1a3a2a}[data-color-mode=dark] .gql-docs .gql-callout{background:#1e1e1e}[data-color-mode=dark] .gql-docs a.gql-nav-link:hover{background:#2a2a2a}[data-color-mode=dark] .gql-docs .gql-nav-active{background:#2a2a2a}[data-color-mode=dark] .gql-docs .gql-ex-select-label{background:#2a2a2a}[data-color-mode=dark] .gql-docs .gql-sidebar-label{background:#161616}[data-color-mode=dark] .gql-docs .gql-response-label{background:#161616}@media (prefers-color-scheme:dark){[data-color-mode=system] .gql-docs{--gql-border:#333;--gql-text:#e0e0e0;--gql-text-muted:#999;--gql-text-link:#58a6ff;--gql-accent:#3fb980;--gql-badge-required:#f97583;--gql-badge-bg-required:#3d1a1e}[data-color-mode=system] .gql-docs .gql-badge-non-null{background:#1a3a2a}[data-color-mode=system] .gql-docs .gql-callout{background:#1e1e1e}[data-color-mode=system] .gql-docs a.gql-nav-link:hover{background:#2a2a2a}[data-color-mode=system] .gql-docs .gql-nav-active{background:#2a2a2a}[data-color-mode=system] .gql-docs .gql-ex-select-label{background:#2a2a2a}[data-color-mode=system] .gql-docs .gql-sidebar-label{background:#161616}[data-color-mode=system] .gql-docs .gql-response-label{background:#161616}}/*! END HUB_CUSTOM_STYLES */</style><link rel="alternate" type="text/markdown" href="current_url.md"><meta name="loadedProject" content="og-restrpc"><script>var storedColorMode = `system` === 'system' ? window.localStorage.getItem('color-scheme') : `system`
document.querySelector('[data-color-mode]').setAttribute('data-color-mode', storedColorMode)</script><script id="config" type="application/json" data-json="{&quot;algoliaIndex&quot;:&quot;readme_search_v2&quot;,&quot;amplitude&quot;:{&quot;apiKey&quot;:&quot;dc8065a65ef83d6ad23e37aaf014fc84&quot;,&quot;enabled&quot;:true},&quot;api&quot;:{&quot;upload&quot;:{&quot;fileSizeLimit&quot;:10485760,&quot;fileSizeLimitFormatted&quot;:&quot;10MB&quot;}},&quot;asset_url&quot;:&quot;https://cdn.readme.io&quot;,&quot;dashDomain&quot;:&quot;dash.readme.com&quot;,&quot;domain&quot;:&quot;readme.io&quot;,&quot;domainFull&quot;:&quot;https://dash.readme.com&quot;,&quot;encryptedLocalStorageKey&quot;:&quot;ekfls-2025-03-27&quot;,&quot;fullstory&quot;:{&quot;enabled&quot;:true,&quot;orgId&quot;:&quot;FSV9A&quot;},&quot;git&quot;:{&quot;preview&quot;:&quot;https://githug-prod.gitto.rdme.io&quot;,&quot;sync&quot;:{&quot;bitbucket&quot;:{&quot;installationLink&quot;:&quot;https://developer.atlassian.com/console/install/310151e6-ca1a-4a44-9af6-1b523fea0561?signature=AYABeMn9vqFkrg%2F1DrJAQxSyVf4AAAADAAdhd3Mta21zAEthcm46YXdzOmttczp1cy13ZXN0LTI6NzA5NTg3ODM1MjQzOmtleS83MDVlZDY3MC1mNTdjLTQxYjUtOWY5Yi1lM2YyZGNjMTQ2ZTcAuAECAQB4IOp8r3eKNYw8z2v%2FEq3%2FfvrZguoGsXpNSaDveR%2FF%2Fo0BHUxIjSWx71zNK2RycuMYSgAAAH4wfAYJKoZIhvcNAQcGoG8wbQIBADBoBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDOJgARbqndU9YM%2FRdQIBEIA7unpCah%2BIu53NA72LkkCDhNHOv%2BgRD7agXAO3jXqw0%2FAcBOB0%2F5LmpzB5f6B1HpkmsAN2i2SbsFL30nkAB2F3cy1rbXMAS2Fybjphd3M6a21zOmV1LXdlc3QtMTo3MDk1ODc4MzUyNDM6a2V5LzQ2MzBjZTZiLTAwYzMtNGRlMi04NzdiLTYyN2UyMDYwZTVjYwC4AQICAHijmwVTMt6Oj3F%2B0%2B0cVrojrS8yZ9ktpdfDxqPMSIkvHAGT%2FMTvCxC3XwnwlulZe975AAAAfjB8BgkqhkiG9w0BBwagbzBtAgEAMGgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMMUUe9d1YmFOo373TAgEQgDuJo7TayM6NL19Sj9RPooRrl8rYxwKgvu9gkLNc3GuyyovWI1xA2qTr0LQzMRsf3imrAWsywzPcsjnvuAAHYXdzLWttcwBLYXJuOmF3czprbXM6dXMtZWFzdC0xOjcwOTU4NzgzNTI0MzprZXkvNmMxMjBiYTAtNGNkNS00OTg1LWI4MmUtNDBhMDQ5NTJjYzU3ALgBAgIAeLKa7Dfn9BgbXaQmJGrkKztjV4vrreTkqr7wGwhqIYs5AZR28Sibv2eBxSIg2MydtvEAAAB%2BMHwGCSqGSIb3DQEHBqBvMG0CAQAwaAYJKoZIhvcNAQcBMB4GCWCGSAFlAwQBLjARBAzzWhThsIgJwrr%2FY2ECARCAOxoaW9pob21lweyAfrIm6Fw7gd8D%2B%2F8LHk4rl3jjULDM35%2FVPuqBrqKunYZSVCCGNGB3RqpQJr%2FasASiAgAAAAAMAAAQAAAAAAAAAAAAAAAAAEokowLKsF1tMABEq%2BKNyJP%2F%2F%2F%2F%2FAAAAAQAAAAAAAAAAAAAAAQAAADJLzRcp6MkqKR43PUjOiRxxbxXYhLc6vFXEutK3%2BQ71yuPq4dC8pAHruOVQpvVcUSe8dptV8c7wR8BTJjv%2F%2FNe8r0g%3D&amp;product=bitbucket&quot;}}},&quot;metrics&quot;:{&quot;billingCronEnabled&quot;:&quot;true&quot;,&quot;dashUrl&quot;:&quot;https://m.readme.io&quot;,&quot;defaultUrl&quot;:&quot;https://m.readme.io&quot;,&quot;exportMaxRetries&quot;:12,&quot;wsUrl&quot;:&quot;wss://m.readme.io&quot;},&quot;micro&quot;:{&quot;baseUrl&quot;:&quot;https://micro-beta.readme.com&quot;},&quot;novuNotification&quot;:{&quot;appId&quot;:&quot;ob_MiAPOPqgP&quot;},&quot;proxyUrl&quot;:&quot;https://try.readme.io&quot;,&quot;readmeRecaptchaSiteKey&quot;:&quot;6LesVBYpAAAAAESOCHOyo2kF9SZXPVb54Nwf3i2x&quot;,&quot;releaseVersion&quot;:&quot;5.715.0&quot;,&quot;reservedWords&quot;:{&quot;tools&quot;:[&quot;execute-request&quot;,&quot;get-endpoint&quot;,&quot;get-server-variables&quot;,&quot;list-endpoints&quot;,&quot;list-specs&quot;,&quot;search-endpoints&quot;,&quot;search&quot;,&quot;fetch&quot;]},&quot;sentry&quot;:{&quot;dsn&quot;:&quot;https://3bbe57a973254129bcb93e47dc0cc46f@o343074.ingest.sentry.io/2052166&quot;,&quot;enabled&quot;:true},&quot;shMigration&quot;:{&quot;promoVideo&quot;:&quot;&quot;,&quot;forceWaitlist&quot;:false,&quot;migrationPreview&quot;:false},&quot;sslBaseDomain&quot;:&quot;readmessl.com&quot;,&quot;sslGenerationService&quot;:&quot;ssl.readmessl.com&quot;,&quot;stripePk&quot;:&quot;pk_live_5103PML2qXbDukVh7GDAkQoR4NSuLqy8idd5xtdm9407XdPR6o3bo663C1ruEGhXJjpnb2YCpj8EU1UvQYanuCjtr00t1DRCf2a&quot;,&quot;superHub&quot;:{&quot;newProjectsEnabled&quot;:true},&quot;wootric&quot;:{&quot;accountToken&quot;:&quot;NPS-122b75a4&quot;,&quot;enabled&quot;:true}}"></script></head><body class="body-none theme-line header-solid header-bg-size-auto header-bg-pos-tl header-overlay-triangles reference-layout-column lumosity-normal no-sidebar"><div id="ssr-top"></div><div id="ssr-main"><div class="App ThemeContext ThemeContext_dark ThemeContext_compact ThemeContext_line" style="--color-primary:#493e90;--color-primary-inverse:#fff;--color-primary-alt:#271d64;--color-primary-darken-10:#372f6c;--color-primary-darken-20:#251f49;--color-primary-alpha-25:rgba(73, 62, 144, 0.25);--color-link-primary:#219050;--color-link-primary-dark-override:#219050;--color-link-button:#219050;--color-link-button-text:#fff;--color-link-button-border:rgba(255, 255, 255, 0.2);--color-link-button-darken-5:#1c7b44;--color-link-button-darken-10:#176639;--color-link-button-alpha-50:rgba(33, 144, 80, 0.5);--color-link-button-alpha-25:rgba(33, 144, 80, 0.25);--color-link-primary-darken-5:#1c7b44;--color-link-primary-darken-10:#176639;--color-link-primary-darken-20:#0e3d22;--color-link-primary-alpha-50:rgba(33, 144, 80, 0.5);--color-link-primary-alpha-25:rgba(33, 144, 80, 0.25);--color-link-background:rgba(33, 144, 80, 0.09);--color-link-text:#fff;--color-tab-active:#493e90;--color-login-link:#219050;--color-login-link-text:#fff;--color-login-link-darken-10:#176639;--color-login-link-primary-alpha-50:rgba(33, 144, 80, 0.5)"><div class="SuperHub2RNxzk6HzHiJ rm-ReadMe"><div class="ContentWithOwlbotx4PaFDoA1KMz"><div class="ContentWithOwlbot-content2X1XexaN8Lf2"><header class="Header3zzata9F_ZPQ rm-Header_compact Header_collapsible3n0YXfOvb_Al rm-Header"><div class="rm-Header-top Header-topuTMpygDG4e1V Header-top_compact2QxpUjyZpLPZ"><div class="rm-Container rm-Container_flex"><div style="outline:none" tabindex="-1"><a href="#content" target="_self" class="Button Button_md rm-JumpTo Header-jumpTo3IWKQXmhSI5D Button_primary">Jump to Content</a></div><div class="rm-Header-left Header-leftADQdGVqx1wqU"><a class="rm-Logo Header-logo1Xy41PtkzbdG" href="/reference" target="_self"><img alt="Ordergroove API Reference" class="rm-Logo-img Header-logo-img3YvV4lcGKkeb Header-logo-img_small1Whup8HPsbv4" src="https://files.readme.io/6fdeecee3b160d06768dc696c4c0fe8ebd672b51f1e65e1e54e375a42893c599-short_white_bg.png"/></a></div><div class="rm-Header-left Header-leftADQdGVqx1wqU Header-left_mobile1RG-X93lx6PF"><div><button aria-label="Toggle navigation menu" class="icon-menu menu3d6DYNDa3tk5" type="button"></button><div class=""><div class="Flyout95xhYIIoTKtc undefined rm-Flyout" data-testid="flyout"><div class="MobileFlyout1hHJpUd-nYkd"><a class="rm-MobileFlyout-item NavItem-item1gDDTqaXGhm1 NavItem-item_mobile1qG3gd-Mkck- " href="/docs" target="_self"><i class="icon-guides NavItem-badge1qOxpfTiALoz rm-Header-bottom-link-icon"></i><span class="NavItem-textSlZuuL489uiw">Guides</span></a><a class="rm-MobileFlyout-item NavItem-item1gDDTqaXGhm1 NavItem-item_mobile1qG3gd-Mkck- " href="/reference" target="_self"><i class="icon-references NavItem-badge1qOxpfTiALoz rm-Header-bottom-link-icon"></i><span class="NavItem-textSlZuuL489uiw">API Reference</span></a><a class="rm-MobileFlyout-item NavItem-item1gDDTqaXGhm1 NavItem-item_mobile1qG3gd-Mkck- " href="https://help.ordergroove.com/hc/en-us" rel="noopener" target="_blank" to="https://help.ordergroove.com/hc/en-us"><span class="NavItem-textSlZuuL489uiw">Knowledge Center</span></a><a class="rm-MobileFlyout-item NavItem-item1gDDTqaXGhm1 NavItem-item_mobile1qG3gd-Mkck- " href="https://academy.ordergroove.com/hc/en-us" rel="noopener" target="_blank" to="https://academy.ordergroove.com/hc/en-us"><span class="NavItem-textSlZuuL489uiw">Academy</span></a><hr class="MobileFlyout-divider10xf7R2X1MeW"/><a class="MobileFlyout-logo3Lq1eTlk1K76 Header-logo1Xy41PtkzbdG rm-Logo" href="/reference" target="_self"><img alt="Ordergroove API Reference" class="Header-logo-img3YvV4lcGKkeb rm-Logo-img" src="https://files.readme.io/6fdeecee3b160d06768dc696c4c0fe8ebd672b51f1e65e1e54e375a42893c599-short_white_bg.png"/></a></div></div></div></div><div class="Header-left-nav2xWPWMNHOGf_"><i aria-hidden="true" class="undefined Header-left-nav-icon10glJKFwewOv"></i></div></div><div class="rm-Header-right Header-right21PC2XTT6aMg"><span class="Header-right_desktop14ja01RUQ7HE"></span><div class="Header-searchtb6Foi0-D9Vx"><button aria-label="Search ⌘k" class="rm-SearchToggle" data-symbol="⌘"><div class="rm-SearchToggle-icon icon-search1"></div></button></div><div class="ThemeToggle-wrapper1ZcciJoF3Lq3 Dropdown Dropdown_closed" data-testid="dropdown-container"><button aria-label="Toggle color scheme" id="ThemeToggle-button-static-id-placeholder" aria-haspopup="dialog" class="Button Button_sm rm-ThemeToggle ThemeToggle2xLp9tbEJ0XB Dropdown-toggle Button_primary_ghost Button_primary" type="button"><svg aria-labelledby="ThemeToggle-button-static-id-placeholder" class="Icon ThemeToggle-Icon22I6nqvxacln ThemeToggle-Icon_active2ocLaPY47U28" role="img" viewBox="0 0 24 24"><path class="ThemeToggle-Icon-raysbSO3FKsq2hn" d="M12 2v2"></path><path d="M14.837 16.385a6 6 0 1 1-7.223-7.222c.624-.147.97.66.715 1.248a4 4 0 0 0 5.26 5.259c.589-.255 1.396.09 1.248.715"></path><path d="M16 12a4 4 0 0 0-4-4"></path><path class="ThemeToggle-Icon-raysbSO3FKsq2hn" d="m19 5-1.256 1.256"></path><path class="ThemeToggle-Icon-raysbSO3FKsq2hn" d="M20 12h2"></path></svg><svg aria-labelledby="ThemeToggle-button-static-id-placeholder" class="Icon ThemeToggle-Icon22I6nqvxacln ThemeToggle-Icon_dark3c1eP_qTU7uF" role="img" viewBox="0 0 24 24"><path d="M19 14.79C18.8427 16.4922 18.2039 18.1144 17.1582 19.4668C16.1126 20.8192 14.7035 21.8458 13.0957 22.4265C11.4879 23.0073 9.74798 23.1181 8.0795 22.7461C6.41102 22.3741 4.88299 21.5345 3.67423 20.3258C2.46546 19.117 1.62594 17.589 1.25391 15.9205C0.881876 14.252 0.992717 12.5121 1.57346 10.9043C2.1542 9.29651 3.18083 7.88737 4.53321 6.84175C5.8856 5.79614 7.5078 5.15731 9.21 5C8.21341 6.34827 7.73385 8.00945 7.85853 9.68141C7.98322 11.3534 8.70386 12.9251 9.8894 14.1106C11.0749 15.2961 12.6466 16.0168 14.3186 16.1415C15.9906 16.2662 17.6517 15.7866 19 14.79Z"></path><path class="ThemeToggle-Icon-star2kOSzvXrVCbT" d="M18.3707 1C18.3707 3.22825 16.2282 5.37069 14 5.37069C16.2282 5.37069 18.3707 7.51313 18.3707 9.74138C18.3707 7.51313 20.5132 5.37069 22.7414 5.37069C20.5132 5.37069 18.3707 3.22825 18.3707 1Z"></path></svg><svg aria-labelledby="ThemeToggle-button-static-id-placeholder" class="Icon ThemeToggle-Icon22I6nqvxacln" role="img" viewBox="0 0 24 24"><path class="ThemeToggle-Icon-raysbSO3FKsq2hn" d="M12 1V3"></path><path class="ThemeToggle-Icon-raysbSO3FKsq2hn" d="M18.36 5.64L19.78 4.22"></path><path class="ThemeToggle-Icon-raysbSO3FKsq2hn" d="M21 12H23"></path><path class="ThemeToggle-Icon-raysbSO3FKsq2hn" d="M18.36 18.36L19.78 19.78"></path><path class="ThemeToggle-Icon-raysbSO3FKsq2hn" d="M12 21V23"></path><path class="ThemeToggle-Icon-raysbSO3FKsq2hn" d="M4.22 19.78L5.64 18.36"></path><path class="ThemeToggle-Icon-raysbSO3FKsq2hn" d="M1 12H3"></path><path class="ThemeToggle-Icon-raysbSO3FKsq2hn" d="M4.22 4.22L5.64 5.64"></path><path d="M12 17C14.7614 17 17 14.7614 17 12C17 9.23858 14.7614 7 12 7C9.23858 7 7 9.23858 7 12C7 14.7614 9.23858 17 12 17Z"></path></svg></button></div></div></div></div><div class="Header-bottom2eLKOFXMEmh5 Header-bottom_compact rm-Header-bottom Header-bottom_withOwlbot3wuKp8NLXCqs"><div class="rm-Container rm-Container_flex"><div style="outline:none" tabindex="-1"><a href="#content" target="_self" class="Button Button_md rm-JumpTo Header-jumpTo3IWKQXmhSI5D Button_primary">Jump to Content</a></div><div class="rm-Header-left rm-Header-left_logo Header-leftADQdGVqx1wqU Header-left_compact3VLkb6FDGwKW"><a class="rm-Logo Header-logo1Xy41PtkzbdG" href="/reference" target="_self"><img alt="Ordergroove API Reference" class="rm-Logo-img Header-logo-img3YvV4lcGKkeb Header-logo-img_small1Whup8HPsbv4" src="https://files.readme.io/6fdeecee3b160d06768dc696c4c0fe8ebd672b51f1e65e1e54e375a42893c599-short_white_bg.png"/></a></div><nav aria-label="Primary navigation" class="Header-leftADQdGVqx1wqU Header-subnavnVH8URdkgvEl" role="navigation"><a class="Button Button_md rm-Header-link rm-Header-bottom-link Button_slate_text Header-bottom-link_mobile " href="/docs" target="_self"><i class="icon-guides rm-Header-bottom-link-icon"></i><span>Guides</span></a><a class="Button Button_md rm-Header-link rm-Header-bottom-link Button_slate_text Header-bottom-link_mobile " href="/reference" target="_self"><i class="icon-references rm-Header-bottom-link-icon"></i><span>API Reference</span></a><a class="Button Button_md rm-Header-link rm-Header-bottom-link Button_slate_text Header-bottom-link_mobile " href="https://help.ordergroove.com/hc/en-us" target="_self" to="https://help.ordergroove.com/hc/en-us"><span>Knowledge Center</span></a><a class="Button Button_md rm-Header-link rm-Header-bottom-link Button_slate_text Header-bottom-link_mobile " href="https://academy.ordergroove.com/hc/en-us" target="_self" to="https://academy.ordergroove.com/hc/en-us"><span>Academy</span></a><div class="Header-subnav-tabyNLkcOA6xAra" style="transform:translateX(0px);width:0"></div></nav><div class="rm-Header-right Header-right21PC2XTT6aMg Header-right_desktop14ja01RUQ7HE"><div class="ThemeToggle-wrapper1ZcciJoF3Lq3 Dropdown Dropdown_closed" data-testid="dropdown-container"><button aria-label="Toggle color scheme" id="ThemeToggle-button-static-id-placeholder" aria-haspopup="dialog" class="Button Button_sm rm-ThemeToggle ThemeToggle2xLp9tbEJ0XB Dropdown-toggle Button_primary_ghost Button_primary" type="button"><svg aria-labelledby="ThemeToggle-button-static-id-placeholder" class="Icon ThemeToggle-Icon22I6nqvxacln ThemeToggle-Icon_active2ocLaPY47U28" role="img" viewBox="0 0 24 24"><path class="ThemeToggle-Icon-raysbSO3FKsq2hn" d="M12 2v2"></path><path d="M14.837 16.385a6 6 0 1 1-7.223-7.222c.624-.147.97.66.715 1.248a4 4 0 0 0 5.26 5.259c.589-.255 1.396.09 1.248.715"></path><path d="M16 12a4 4 0 0 0-4-4"></path><path class="ThemeToggle-Icon-raysbSO3FKsq2hn" d="m19 5-1.256 1.256"></path><path class="ThemeToggle-Icon-raysbSO3FKsq2hn" d="M20 12h2"></path></svg><svg aria-labelledby="ThemeToggle-button-static-id-placeholder" class="Icon ThemeToggle-Icon22I6nqvxacln ThemeToggle-Icon_dark3c1eP_qTU7uF" role="img" viewBox="0 0 24 24"><path d="M19 14.79C18.8427 16.4922 18.2039 18.1144 17.1582 19.4668C16.1126 20.8192 14.7035 21.8458 13.0957 22.4265C11.4879 23.0073 9.74798 23.1181 8.0795 22.7461C6.41102 22.3741 4.88299 21.5345 3.67423 20.3258C2.46546 19.117 1.62594 17.589 1.25391 15.9205C0.881876 14.252 0.992717 12.5121 1.57346 10.9043C2.1542 9.29651 3.18083 7.88737 4.53321 6.84175C5.8856 5.79614 7.5078 5.15731 9.21 5C8.21341 6.34827 7.73385 8.00945 7.85853 9.68141C7.98322 11.3534 8.70386 12.9251 9.8894 14.1106C11.0749 15.2961 12.6466 16.0168 14.3186 16.1415C15.9906 16.2662 17.6517 15.7866 19 14.79Z"></path><path class="ThemeToggle-Icon-star2kOSzvXrVCbT" d="M18.3707 1C18.3707 3.22825 16.2282 5.37069 14 5.37069C16.2282 5.37069 18.3707 7.51313 18.3707 9.74138C18.3707 7.51313 20.5132 5.37069 22.7414 5.37069C20.5132 5.37069 18.3707 3.22825 18.3707 1Z"></path></svg><svg aria-labelledby="ThemeToggle-button-static-id-placeholder" class="Icon ThemeToggle-Icon22I6nqvxacln" role="img" viewBox="0 0 24 24"><path class="ThemeToggle-Icon-raysbSO3FKsq2hn" d="M12 1V3"></path><path class="ThemeToggle-Icon-raysbSO3FKsq2hn" d="M18.36 5.64L19.78 4.22"></path><path class="ThemeToggle-Icon-raysbSO3FKsq2hn" d="M21 12H23"></path><path class="ThemeToggle-Icon-raysbSO3FKsq2hn" d="M18.36 18.36L19.78 19.78"></path><path class="ThemeToggle-Icon-raysbSO3FKsq2hn" d="M12 21V23"></path><path class="ThemeToggle-Icon-raysbSO3FKsq2hn" d="M4.22 19.78L5.64 18.36"></path><path class="ThemeToggle-Icon-raysbSO3FKsq2hn" d="M1 12H3"></path><path class="ThemeToggle-Icon-raysbSO3FKsq2hn" d="M4.22 4.22L5.64 5.64"></path><path d="M12 17C14.7614 17 17 14.7614 17 12C17 9.23858 14.7614 7 12 7C9.23858 7 7 9.23858 7 12C7 14.7614 9.23858 17 12 17Z"></path></svg></button></div></div></div></div><div class="hub-search-results--reactApp " id="hub-search-results"><div class="hub-container"><div class="modal-backdrop rm-SearchModal" role="button" tabindex="0"></div></div></div></header><main class="SuperHubCustomPage rm-CustomPage"><div class="SuperHubCustomPage-content2y25YXtWEbiK"><header class="SuperHubCustomPage-content-header"><h1 class="SuperHubCustomPage-title19mYd6i5mTYj">Orders</h1></header><div dehydrated="" class="rm-Markdown markdown-body" data-testid="RDMD"><div class="rdmd-html">
<!-- requires graphql-docs.css in README.io Appearance > Custom CSS -->
<div class="gql-docs">

  <div class="gql-layout">

<nav class="gql-nav">
<div class="gql-nav-inner">
<details class="gql-nav-section" open>
<summary>Queries</summary>
<ul class="gql-nav-list">
<li><a class="gql-nav-link" href="graphql-order">order</a></li>
<li><span class="gql-nav-link gql-nav-active">orders</span></li>
<li><a class="gql-nav-link" href="graphql-subscription">subscription</a></li>
<li><a class="gql-nav-link" href="graphql-subscriptions">subscriptions</a></li>
</ul>
</details>
<details class="gql-nav-section" open>
<summary>Objects</summary>
<ul class="gql-nav-list">
<li><a class="gql-nav-link" href="graphql-type-AddressType">Address</a></li>
<li><a class="gql-nav-link" href="graphql-type-BaseIncentiveType">BaseIncentive</a></li>
<li><a class="gql-nav-link" href="graphql-type-CancelReasonType">CancelReason</a></li>
<li><a class="gql-nav-link" href="graphql-type-ComponentType">Component</a></li>
<li><a class="gql-nav-link" href="graphql-type-CustomerType">Customer</a></li>
<li><a class="gql-nav-link" href="graphql-type-DiscountIncentiveType">DiscountIncentive</a></li>
<li><a class="gql-nav-link" href="graphql-type-FreeTrialSubscriptionContextType">FreeTrialSubscriptionContext</a></li>
<li><a class="gql-nav-link" href="graphql-type-GiftIncentiveType">GiftIncentive</a></li>
<li><a class="gql-nav-link" href="graphql-type-GranteeType">Grantee</a></li>
<li><a class="gql-nav-link" href="graphql-type-IncentiveType">Incentive</a></li>
<li><a class="gql-nav-link" href="graphql-type-ItemType">Item</a></li>
<li><a class="gql-nav-link" href="graphql-type-ItemsPage">ItemsPage</a></li>
<li><a class="gql-nav-link" href="graphql-type-OneTimeIncentiveType">OneTimeIncentive</a></li>
<li><a class="gql-nav-link" href="graphql-type-OrderConnection">OrderConnection</a></li>
<li><a class="gql-nav-link" href="graphql-type-OrderEdge">OrderEdge</a></li>
<li><a class="gql-nav-link" href="graphql-type-OrderType">Order</a></li>
<li><a class="gql-nav-link" href="graphql-type-PaymentType">Payment</a></li>
<li><a class="gql-nav-link" href="graphql-type-PrepaidSubscriptionContextType">PrepaidSubscriptionContext</a></li>
<li><a class="gql-nav-link" href="graphql-type-ProductGroupType">ProductGroup</a></li>
<li><a class="gql-nav-link" href="graphql-type-ProductType">Product</a></li>
<li><a class="gql-nav-link" href="graphql-type-QueuedActionType">QueuedAction</a></li>
<li><a class="gql-nav-link" href="graphql-type-SubscriptionConnection">SubscriptionConnection</a></li>
<li><a class="gql-nav-link" href="graphql-type-SubscriptionEdge">SubscriptionEdge</a></li>
<li><a class="gql-nav-link" href="graphql-type-SubscriptionType">Subscription</a></li>
</ul>
</details>
</div>
</nav>

    <div class="gql-main">
<h2 class="gql-section-heading">Arguments</h2>
<ul class="gql-arg-list">
<li class="gql-arg-item">
<div class="gql-arg-header">
<span class="gql-arg-name">after</span>
<span class="gql-type-tag">String</span>
</div>
<div class="gql-arg-desc">Cursor to paginate forward from.</div>
</li>
<li class="gql-arg-item">
<div class="gql-arg-header">
<span class="gql-arg-name">before</span>
<span class="gql-type-tag">String</span>
</div>
<div class="gql-arg-desc">Cursor to paginate backward from.</div>
</li>
<li class="gql-arg-item">
<div class="gql-arg-header">
<span class="gql-arg-name">customer</span>
<span class="gql-type-tag">String</span>
</div>
<div class="gql-arg-desc">Filter by customer ID.</div>
</li>
<li class="gql-arg-item">
<div class="gql-arg-header">
<span class="gql-arg-name">first</span>
<span class="gql-type-tag">Int</span>
</div>
<div class="gql-arg-desc">Return the first N results.</div>
</li>
<li class="gql-arg-item">
<div class="gql-arg-header">
<span class="gql-arg-name">includePrepaidOrders</span>
<span class="gql-type-tag">Boolean</span>
</div>
<div class="gql-arg-desc">Include prepaid orders in results. Defaults to true.</div>
</li>
<li class="gql-arg-item">
<div class="gql-arg-header">
<span class="gql-arg-name">last</span>
<span class="gql-type-tag">Int</span>
</div>
<div class="gql-arg-desc">Return the last N results.</div>
</li>
<li class="gql-arg-item">
<div class="gql-arg-header">
<span class="gql-arg-name">place</span>
<span class="gql-type-tag">Date</span>
</div>
<div class="gql-arg-desc">Filter by exact placement date (YYYY-MM-DD).</div>
</li>
<li class="gql-arg-item">
<div class="gql-arg-header">
<span class="gql-arg-name">placeEnd</span>
<span class="gql-type-tag">Date</span>
</div>
<div class="gql-arg-desc">Filter orders placed on or before this date (YYYY-MM-DD).</div>
</li>
<li class="gql-arg-item">
<div class="gql-arg-header">
<span class="gql-arg-name">placeStart</span>
<span class="gql-type-tag">Date</span>
</div>
<div class="gql-arg-desc">Filter orders placed on or after this date (YYYY-MM-DD).</div>
</li>
<li class="gql-arg-item">
<div class="gql-arg-header">
<span class="gql-arg-name">status</span>
<span class="gql-type-tag">[Int!]</span>
</div>
<div class="gql-arg-desc">Filter by order status codes.</div>
</li>
<li class="gql-arg-item">
<div class="gql-arg-header">
<span class="gql-arg-name">subscription</span>
<span class="gql-type-tag">String</span>
</div>
<div class="gql-arg-desc">Filter by subscription public ID.</div>
</li>
</ul>
<h2 class="gql-section-heading">Return type: OrderConnection</h2>
<ul class="gql-field-list">
<li>
<details class="gql-nested-type">
<summary>
<span class="gql-field-name">edges</span>
<a class="gql-type-tag" href="graphql-type-OrderEdge">[OrderEdge!]!</a>
<span class="gql-badge gql-badge-non-null">Non-null</span>
<span class="gql-show-fields">Show fields</span>
</summary>
<div class="gql-nested-content">
<div class="gql-nested-type-heading">OrderEdge fields</div>
<ul class="gql-field-list">
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">cursor</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li>
<details class="gql-nested-type">
<summary>
<span class="gql-field-name">node</span>
<a class="gql-type-tag" href="graphql-type-OrderType">OrderType!</a>
<span class="gql-badge gql-badge-non-null">Non-null</span>
<span class="gql-show-fields">Show fields</span>
</summary>
<div class="gql-nested-content">
<div class="gql-nested-type-heading">OrderType fields</div>
<ul class="gql-field-list">
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">cancelled</span>
<span class="gql-type-tag">DateTime</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">created</span>
<span class="gql-type-tag">DateTime</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">currencyCode</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li>
<details class="gql-nested-type">
<summary>
<span class="gql-field-name">customer</span>
<a class="gql-type-tag" href="graphql-type-CustomerType">CustomerType</a>
<span class="gql-show-fields">Show fields</span>
</summary>
<div class="gql-nested-content">
<div class="gql-nested-type-heading">CustomerType fields</div>
<ul class="gql-field-list">
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">created</span>
<span class="gql-type-tag">DateTime!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">email</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">extraData</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">firstName</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">lastName</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">lastUpdated</span>
<span class="gql-type-tag">DateTime!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">live</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">locale</span>
<span class="gql-type-tag">Int</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">merchantUserId</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">phoneNumber</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">phoneType</span>
<span class="gql-type-tag">Int</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">priceCode</span>
<span class="gql-type-tag">String</span>
</div>
</li>
</ul>
</div>
</details>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">discountTotal</span>
<span class="gql-type-tag">Decimal!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">extraData</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">genericErrorCount</span>
<span class="gql-type-tag">Int!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">hasPlan</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li>
<details class="gql-nested-type">
<summary>
<span class="gql-field-name">items</span>
<a class="gql-type-tag" href="graphql-type-ItemsPage">ItemsPage!</a>
<span class="gql-badge gql-badge-non-null">Non-null</span>
<span class="gql-show-fields">Show fields</span>
</summary>
<div class="gql-nested-content">
<div class="gql-nested-type-heading">ItemsPage fields</div>
<ul class="gql-field-list">
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">hasMore</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li>
<details class="gql-nested-type">
<summary>
<span class="gql-field-name">nodes</span>
<a class="gql-type-tag" href="graphql-type-ItemType">[ItemType!]!</a>
<span class="gql-badge gql-badge-non-null">Non-null</span>
<span class="gql-show-fields">Show fields</span>
</summary>
<div class="gql-nested-content">
<div class="gql-nested-type-heading">ItemType fields</div>
<ul class="gql-field-list">
<li>
<details class="gql-nested-type">
<summary>
<span class="gql-field-name">components</span>
<a class="gql-type-tag" href="graphql-type-ProductType">[ProductType!]!</a>
<span class="gql-badge gql-badge-non-null">Non-null</span>
<span class="gql-show-fields">Show fields</span>
</summary>
<div class="gql-nested-content">
<div class="gql-nested-type-heading">ProductType fields</div>
<ul class="gql-field-list">
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">autoshipByDefault</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">autoshipEnabled</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">created</span>
<span class="gql-type-tag">DateTime</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">detailUrl</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">discontinued</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">every</span>
<span class="gql-type-tag">Int</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">everyPeriod</span>
<span class="gql-type-tag">Int</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">externalProductId</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">extraData</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li>
<details class="gql-nested-type">
<summary>
<span class="gql-field-name">groups</span>
<a class="gql-type-tag" href="graphql-type-ProductGroupType">[ProductGroupType!]!</a>
<span class="gql-badge gql-badge-non-null">Non-null</span>
<span class="gql-show-fields">Show fields</span>
</summary>
<div class="gql-nested-content">
<div class="gql-nested-type-heading">ProductGroupType fields</div>
<ul class="gql-field-list">
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">groupType</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">name</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
</ul>
</div>
</details>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">imageUrl</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">lastUpdate</span>
<span class="gql-type-tag">DateTime</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">live</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">name</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">prepaidEligible</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">price</span>
<span class="gql-type-tag">Decimal!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">productType</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">sku</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
</ul>
</div>
</details>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">extraCost</span>
<span class="gql-type-tag">Decimal!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">firstPlaced</span>
<span class="gql-type-tag">DateTime</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">frozen</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">offerPublicId</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">oneTime</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li>
<details class="gql-nested-type">
<summary>
<span class="gql-field-name">oneTimeIncentives</span>
<a class="gql-type-tag" href="graphql-type-OneTimeIncentiveType">[OneTimeIncentiveType!]!</a>
<span class="gql-badge gql-badge-non-null">Non-null</span>
<span class="gql-show-fields">Show fields</span>
</summary>
<div class="gql-nested-content">
<div class="gql-nested-type-heading">OneTimeIncentiveType fields</div>
<ul class="gql-field-list">
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">appliedAt</span>
<span class="gql-type-tag">DateTime</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">created</span>
<span class="gql-type-tag">DateTime!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">description</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">expires</span>
<span class="gql-type-tag">DateTime</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">externalCode</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li>
<details class="gql-nested-type">
<summary>
<span class="gql-field-name">incentive</span>
<a class="gql-type-tag" href="graphql-type-IncentiveType">IncentiveType</a>
<span class="gql-show-fields">Show fields</span>
</summary>
<div class="gql-nested-content">
<div class="gql-nested-type-heading">IncentiveType fields <span class="gql-badge gql-badge-interface">Interface</span></div>
<ul class="gql-field-list">
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">name</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">publicId</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
</ul>
<div class="gql-implementations">
<div class="gql-nested-type-heading">Implemented by</div>
<ul class="gql-impl-list">
<li class="gql-impl-item">
<a class="gql-impl-link" href="graphql-type-BaseIncentiveType">BaseIncentive</a>
</li>
<li class="gql-impl-item">
<a class="gql-impl-link" href="graphql-type-DiscountIncentiveType">DiscountIncentive</a>
<div class="gql-impl-fields">discountType: String!, field: String!, limitPolicy: String, limitValue: Decimal, target: String!, thresholdField: String, thresholdValue: Decimal, value: Decimal!</div>
</li>
<li class="gql-impl-item">
<a class="gql-impl-link" href="graphql-type-GiftIncentiveType">GiftIncentive</a>
<div class="gql-impl-fields">product: ProductType, target: String!</div>
</li>
</ul>
</div>
</div>
</details>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">lastUpdated</span>
<span class="gql-type-tag">DateTime!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">onetimeCouponType</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">publicId</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">stackingType</span>
<span class="gql-type-tag">Int!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
</ul>
</div>
</details>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">orderPublicId</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">price</span>
<span class="gql-type-tag">Decimal!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li>
<details class="gql-nested-type">
<summary>
<span class="gql-field-name">product</span>
<a class="gql-type-tag" href="graphql-type-ProductType">ProductType</a>
<span class="gql-show-fields">Show fields</span>
</summary>
<div class="gql-nested-content">
<div class="gql-nested-type-heading">ProductType fields</div>
<ul class="gql-field-list">
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">autoshipByDefault</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">autoshipEnabled</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">created</span>
<span class="gql-type-tag">DateTime</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">detailUrl</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">discontinued</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">every</span>
<span class="gql-type-tag">Int</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">everyPeriod</span>
<span class="gql-type-tag">Int</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">externalProductId</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">extraData</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li>
<details class="gql-nested-type">
<summary>
<span class="gql-field-name">groups</span>
<a class="gql-type-tag" href="graphql-type-ProductGroupType">[ProductGroupType!]!</a>
<span class="gql-badge gql-badge-non-null">Non-null</span>
<span class="gql-show-fields">Show fields</span>
</summary>
<div class="gql-nested-content">
<div class="gql-nested-type-heading">ProductGroupType fields</div>
<ul class="gql-field-list">
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">groupType</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">name</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
</ul>
</div>
</details>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">imageUrl</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">lastUpdate</span>
<span class="gql-type-tag">DateTime</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">live</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">name</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">prepaidEligible</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">price</span>
<span class="gql-type-tag">Decimal!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">productType</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">sku</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
</ul>
</div>
</details>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">publicId</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">quantity</span>
<span class="gql-type-tag">Int!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li>
<details class="gql-nested-type">
<summary>
<span class="gql-field-name">subscription</span>
<a class="gql-type-tag" href="graphql-type-SubscriptionType">SubscriptionType</a>
<span class="gql-show-fields">Show fields</span>
</summary>
<div class="gql-nested-content">
<div class="gql-nested-type-heading">SubscriptionType fields</div>
<ul class="gql-field-list">
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">cancelReason</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li>
<details class="gql-nested-type">
<summary>
<span class="gql-field-name">cancelReasonCode</span>
<a class="gql-type-tag" href="graphql-type-CancelReasonType">CancelReasonType</a>
<span class="gql-show-fields">Show fields</span>
</summary>
<div class="gql-nested-content">
<div class="gql-nested-type-heading">CancelReasonType fields</div>
<ul class="gql-field-list">
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">code</span>
<span class="gql-type-tag">Int!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">reason</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
</ul>
</div>
</details>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">cancelled</span>
<span class="gql-type-tag">DateTime</span>
</div>
</li>
<li>
<details class="gql-nested-type">
<summary>
<span class="gql-field-name">components</span>
<a class="gql-type-tag" href="graphql-type-ComponentType">[ComponentType!]</a>
<span class="gql-show-fields">Show fields</span>
</summary>
<div class="gql-nested-content">
<div class="gql-nested-type-heading">ComponentType fields</div>
<ul class="gql-field-list">
<li>
<details class="gql-nested-type">
<summary>
<span class="gql-field-name">product</span>
<a class="gql-type-tag" href="graphql-type-ProductType">ProductType</a>
<span class="gql-show-fields">Show fields</span>
</summary>
<div class="gql-nested-content">
<div class="gql-nested-type-heading">ProductType fields</div>
<ul class="gql-field-list">
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">autoshipByDefault</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">autoshipEnabled</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">created</span>
<span class="gql-type-tag">DateTime</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">detailUrl</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">discontinued</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">every</span>
<span class="gql-type-tag">Int</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">everyPeriod</span>
<span class="gql-type-tag">Int</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">externalProductId</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">extraData</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li>
<details class="gql-nested-type">
<summary>
<span class="gql-field-name">groups</span>
<a class="gql-type-tag" href="graphql-type-ProductGroupType">[ProductGroupType!]!</a>
<span class="gql-badge gql-badge-non-null">Non-null</span>
<span class="gql-show-fields">Show fields</span>
</summary>
<div class="gql-nested-content">
<div class="gql-nested-type-heading">ProductGroupType fields</div>
<ul class="gql-field-list">
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">groupType</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">name</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
</ul>
</div>
</details>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">imageUrl</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">lastUpdate</span>
<span class="gql-type-tag">DateTime</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">live</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">name</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">prepaidEligible</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">price</span>
<span class="gql-type-tag">Decimal!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">productType</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">sku</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
</ul>
</div>
</details>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">publicId</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">quantity</span>
<span class="gql-type-tag">Int</span>
</div>
</li>
</ul>
</div>
</details>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">created</span>
<span class="gql-type-tag">DateTime</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">currencyCode</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li>
<details class="gql-nested-type">
<summary>
<span class="gql-field-name">customer</span>
<a class="gql-type-tag" href="graphql-type-CustomerType">CustomerType</a>
<span class="gql-show-fields">Show fields</span>
</summary>
<div class="gql-nested-content">
<div class="gql-nested-type-heading">CustomerType fields</div>
<ul class="gql-field-list">
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">created</span>
<span class="gql-type-tag">DateTime!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">email</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">extraData</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">firstName</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">lastName</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">lastUpdated</span>
<span class="gql-type-tag">DateTime!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">live</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">locale</span>
<span class="gql-type-tag">Int</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">merchantUserId</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">phoneNumber</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">phoneType</span>
<span class="gql-type-tag">Int</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">priceCode</span>
<span class="gql-type-tag">String</span>
</div>
</li>
</ul>
</div>
</details>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">every</span>
<span class="gql-type-tag">Int</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">everyPeriod</span>
<span class="gql-type-tag">Int</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">externalId</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">extraData</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li>
<details class="gql-nested-type">
<summary>
<span class="gql-field-name">freeTrialSubscriptionContext</span>
<a class="gql-type-tag" href="graphql-type-FreeTrialSubscriptionContextType">FreeTrialSubscriptionContextType</a>
<span class="gql-show-fields">Show fields</span>
</summary>
<div class="gql-nested-content">
<div class="gql-nested-type-heading">FreeTrialSubscriptionContextType fields</div>
<ul class="gql-field-list">
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">conversionItem</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">days</span>
<span class="gql-type-tag">Int!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">expiration</span>
<span class="gql-type-tag">DateTime!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">isInFreeTrial</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li>
<details class="gql-nested-type">
<summary>
<span class="gql-field-name">product</span>
<a class="gql-type-tag" href="graphql-type-ProductType">ProductType</a>
<span class="gql-show-fields">Show fields</span>
</summary>
<div class="gql-nested-content">
<div class="gql-nested-type-heading">ProductType fields</div>
<ul class="gql-field-list">
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">autoshipByDefault</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">autoshipEnabled</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">created</span>
<span class="gql-type-tag">DateTime</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">detailUrl</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">discontinued</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">every</span>
<span class="gql-type-tag">Int</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">everyPeriod</span>
<span class="gql-type-tag">Int</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">externalProductId</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">extraData</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li>
<details class="gql-nested-type">
<summary>
<span class="gql-field-name">groups</span>
<a class="gql-type-tag" href="graphql-type-ProductGroupType">[ProductGroupType!]!</a>
<span class="gql-badge gql-badge-non-null">Non-null</span>
<span class="gql-show-fields">Show fields</span>
</summary>
<div class="gql-nested-content">
<div class="gql-nested-type-heading">ProductGroupType fields</div>
<ul class="gql-field-list">
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">groupType</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">name</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
</ul>
</div>
</details>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">imageUrl</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">lastUpdate</span>
<span class="gql-type-tag">DateTime</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">live</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">name</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">prepaidEligible</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">price</span>
<span class="gql-type-tag">Decimal!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">productType</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">sku</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
</ul>
</div>
</details>
</li>
</ul>
</div>
</details>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">frequencyDays</span>
<span class="gql-type-tag">Int</span>
</div>
</li>
<li>
<details class="gql-nested-type">
<summary>
<span class="gql-field-name">grantees</span>
<a class="gql-type-tag" href="graphql-type-GranteeType">[GranteeType!]!</a>
<span class="gql-badge gql-badge-non-null">Non-null</span>
<span class="gql-show-fields">Show fields</span>
</summary>
<div class="gql-nested-content">
<div class="gql-nested-type-heading">GranteeType fields</div>
<ul class="gql-field-list">
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">externalId</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">name</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
</ul>
</div>
</details>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">id</span>
<span class="gql-type-tag">ID!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
<div class="gql-field-desc">The Globally Unique ID of this object</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">live</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">merchantOrderId</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">merchantPublicId</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">offerPublicId</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li>
<details class="gql-nested-type">
<summary>
<span class="gql-field-name">payment</span>
<a class="gql-type-tag" href="graphql-type-PaymentType">PaymentType</a>
<span class="gql-show-fields">Show fields</span>
</summary>
<div class="gql-nested-content">
<div class="gql-nested-type-heading">PaymentType fields</div>
<ul class="gql-field-list">
<li>
<details class="gql-nested-type">
<summary>
<span class="gql-field-name">billingAddress</span>
<a class="gql-type-tag" href="graphql-type-AddressType">AddressType</a>
<span class="gql-show-fields">Show fields</span>
</summary>
<div class="gql-nested-content">
<div class="gql-nested-type-heading">AddressType fields</div>
<ul class="gql-field-list">
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">address</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">address2</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">city</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">companyName</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">countryCode</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">created</span>
<span class="gql-type-tag">DateTime!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">fax</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">firstName</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">label</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">lastName</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">live</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">phone</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">priceCode</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">publicId</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">stateProvinceCode</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">tokenId</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">zipPostalCode</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
</ul>
</div>
</details>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">ccExpDate</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">ccHolder</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">ccNumberEnding</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">ccType</span>
<span class="gql-type-tag">Int</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">created</span>
<span class="gql-type-tag">DateTime!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">cycle</span>
<span class="gql-type-tag">Int</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">cycleStatus</span>
<span class="gql-type-tag">Int</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">label</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">lastUpdated</span>
<span class="gql-type-tag">DateTime!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">live</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">paymentMethod</span>
<span class="gql-type-tag">Int</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">publicId</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">tokenId</span>
<span class="gql-type-tag">String</span>
</div>
</li>
</ul>
</div>
</details>
</li>
<li>
<details class="gql-nested-type">
<summary>
<span class="gql-field-name">prepaidSubscriptionContext</span>
<a class="gql-type-tag" href="graphql-type-PrepaidSubscriptionContextType">PrepaidSubscriptionContextType</a>
<span class="gql-show-fields">Show fields</span>
</summary>
<div class="gql-nested-content">
<div class="gql-nested-type-heading">PrepaidSubscriptionContextType fields</div>
<ul class="gql-field-list">
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">lastRenewalRevenue</span>
<span class="gql-type-tag">Decimal!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">prepaidOrdersPerBilling</span>
<span class="gql-type-tag">Int!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">prepaidOrdersRemaining</span>
<span class="gql-type-tag">Int!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">prepaidOriginMerchantOrderId</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">renewalBehavior</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
</ul>
</div>
</details>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">price</span>
<span class="gql-type-tag">Decimal</span>
</div>
</li>
<li>
<details class="gql-nested-type">
<summary>
<span class="gql-field-name">product</span>
<a class="gql-type-tag" href="graphql-type-ProductType">ProductType</a>
<span class="gql-show-fields">Show fields</span>
</summary>
<div class="gql-nested-content">
<div class="gql-nested-type-heading">ProductType fields</div>
<ul class="gql-field-list">
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">autoshipByDefault</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">autoshipEnabled</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">created</span>
<span class="gql-type-tag">DateTime</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">detailUrl</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">discontinued</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">every</span>
<span class="gql-type-tag">Int</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">everyPeriod</span>
<span class="gql-type-tag">Int</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">externalProductId</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">extraData</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li>
<details class="gql-nested-type">
<summary>
<span class="gql-field-name">groups</span>
<a class="gql-type-tag" href="graphql-type-ProductGroupType">[ProductGroupType!]!</a>
<span class="gql-badge gql-badge-non-null">Non-null</span>
<span class="gql-show-fields">Show fields</span>
</summary>
<div class="gql-nested-content">
<div class="gql-nested-type-heading">ProductGroupType fields</div>
<ul class="gql-field-list">
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">groupType</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">name</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
</ul>
</div>
</details>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">imageUrl</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">lastUpdate</span>
<span class="gql-type-tag">DateTime</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">live</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">name</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">prepaidEligible</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">price</span>
<span class="gql-type-tag">Decimal!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">productType</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">sku</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
</ul>
</div>
</details>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">publicId</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">quantity</span>
<span class="gql-type-tag">Int!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li>
<details class="gql-nested-type">
<summary>
<span class="gql-field-name">queuedActions</span>
<a class="gql-type-tag" href="graphql-type-QueuedActionType">[QueuedActionType!]</a>
<span class="gql-show-fields">Show fields</span>
</summary>
<div class="gql-nested-content">
<div class="gql-nested-type-heading">QueuedActionType fields</div>
<ul class="gql-field-list">
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">date</span>
<span class="gql-type-tag">DateTime</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">index</span>
<span class="gql-type-tag">Int!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">ordinal</span>
<span class="gql-type-tag">Int!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">publicId</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">skip</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
</ul>
</div>
</details>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">reminderDays</span>
<span class="gql-type-tag">Int</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">sessionId</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li>
<details class="gql-nested-type">
<summary>
<span class="gql-field-name">shippingAddress</span>
<a class="gql-type-tag" href="graphql-type-AddressType">AddressType</a>
<span class="gql-show-fields">Show fields</span>
</summary>
<div class="gql-nested-content">
<div class="gql-nested-type-heading">AddressType fields</div>
<ul class="gql-field-list">
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">address</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">address2</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">city</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">companyName</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">countryCode</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">created</span>
<span class="gql-type-tag">DateTime!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">fax</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">firstName</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">label</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">lastName</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">live</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">phone</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">priceCode</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">publicId</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">stateProvinceCode</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">tokenId</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">zipPostalCode</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
</ul>
</div>
</details>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">startDate</span>
<span class="gql-type-tag">Date!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">subscriptionType</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">updated</span>
<span class="gql-type-tag">DateTime</span>
</div>
</li>
</ul>
</div>
</details>
</li>
<li>
<details class="gql-nested-type">
<summary>
<span class="gql-field-name">subscriptionComponent</span>
<a class="gql-type-tag" href="graphql-type-ComponentType">ComponentType</a>
<span class="gql-show-fields">Show fields</span>
</summary>
<div class="gql-nested-content">
<div class="gql-nested-type-heading">ComponentType fields</div>
<ul class="gql-field-list">
<li>
<details class="gql-nested-type">
<summary>
<span class="gql-field-name">product</span>
<a class="gql-type-tag" href="graphql-type-ProductType">ProductType</a>
<span class="gql-show-fields">Show fields</span>
</summary>
<div class="gql-nested-content">
<div class="gql-nested-type-heading">ProductType fields</div>
<ul class="gql-field-list">
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">autoshipByDefault</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">autoshipEnabled</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">created</span>
<span class="gql-type-tag">DateTime</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">detailUrl</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">discontinued</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">every</span>
<span class="gql-type-tag">Int</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">everyPeriod</span>
<span class="gql-type-tag">Int</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">externalProductId</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">extraData</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li>
<details class="gql-nested-type">
<summary>
<span class="gql-field-name">groups</span>
<a class="gql-type-tag" href="graphql-type-ProductGroupType">[ProductGroupType!]!</a>
<span class="gql-badge gql-badge-non-null">Non-null</span>
<span class="gql-show-fields">Show fields</span>
</summary>
<div class="gql-nested-content">
<div class="gql-nested-type-heading">ProductGroupType fields</div>
<ul class="gql-field-list">
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">groupType</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">name</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
</ul>
</div>
</details>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">imageUrl</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">lastUpdate</span>
<span class="gql-type-tag">DateTime</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">live</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">name</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">prepaidEligible</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">price</span>
<span class="gql-type-tag">Decimal!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">productType</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">sku</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
</ul>
</div>
</details>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">publicId</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">quantity</span>
<span class="gql-type-tag">Int</span>
</div>
</li>
</ul>
</div>
</details>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">totalPrice</span>
<span class="gql-type-tag">Decimal!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
</ul>
</div>
</details>
</li>
</ul>
</div>
</details>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">locked</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">merchantPublicId</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li>
<details class="gql-nested-type">
<summary>
<span class="gql-field-name">oneTimeIncentives</span>
<a class="gql-type-tag" href="graphql-type-OneTimeIncentiveType">[OneTimeIncentiveType!]!</a>
<span class="gql-badge gql-badge-non-null">Non-null</span>
<span class="gql-show-fields">Show fields</span>
</summary>
<div class="gql-nested-content">
<div class="gql-nested-type-heading">OneTimeIncentiveType fields</div>
<ul class="gql-field-list">
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">appliedAt</span>
<span class="gql-type-tag">DateTime</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">created</span>
<span class="gql-type-tag">DateTime!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">description</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">expires</span>
<span class="gql-type-tag">DateTime</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">externalCode</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li>
<details class="gql-nested-type">
<summary>
<span class="gql-field-name">incentive</span>
<a class="gql-type-tag" href="graphql-type-IncentiveType">IncentiveType</a>
<span class="gql-show-fields">Show fields</span>
</summary>
<div class="gql-nested-content">
<div class="gql-nested-type-heading">IncentiveType fields <span class="gql-badge gql-badge-interface">Interface</span></div>
<ul class="gql-field-list">
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">name</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">publicId</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
</ul>
<div class="gql-implementations">
<div class="gql-nested-type-heading">Implemented by</div>
<ul class="gql-impl-list">
<li class="gql-impl-item">
<a class="gql-impl-link" href="graphql-type-BaseIncentiveType">BaseIncentive</a>
</li>
<li class="gql-impl-item">
<a class="gql-impl-link" href="graphql-type-DiscountIncentiveType">DiscountIncentive</a>
<div class="gql-impl-fields">discountType: String!, field: String!, limitPolicy: String, limitValue: Decimal, target: String!, thresholdField: String, thresholdValue: Decimal, value: Decimal!</div>
</li>
<li class="gql-impl-item">
<a class="gql-impl-link" href="graphql-type-GiftIncentiveType">GiftIncentive</a>
<div class="gql-impl-fields">product: ProductType, target: String!</div>
</li>
</ul>
</div>
</div>
</details>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">lastUpdated</span>
<span class="gql-type-tag">DateTime!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">onetimeCouponType</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">publicId</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">stackingType</span>
<span class="gql-type-tag">Int!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
</ul>
</div>
</details>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">oosFreeShipping</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">orderMerchantId</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li>
<details class="gql-nested-type">
<summary>
<span class="gql-field-name">payment</span>
<a class="gql-type-tag" href="graphql-type-PaymentType">PaymentType</a>
<span class="gql-show-fields">Show fields</span>
</summary>
<div class="gql-nested-content">
<div class="gql-nested-type-heading">PaymentType fields</div>
<ul class="gql-field-list">
<li>
<details class="gql-nested-type">
<summary>
<span class="gql-field-name">billingAddress</span>
<a class="gql-type-tag" href="graphql-type-AddressType">AddressType</a>
<span class="gql-show-fields">Show fields</span>
</summary>
<div class="gql-nested-content">
<div class="gql-nested-type-heading">AddressType fields</div>
<ul class="gql-field-list">
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">address</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">address2</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">city</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">companyName</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">countryCode</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">created</span>
<span class="gql-type-tag">DateTime!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">fax</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">firstName</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">label</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">lastName</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">live</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">phone</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">priceCode</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">publicId</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">stateProvinceCode</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">tokenId</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">zipPostalCode</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
</ul>
</div>
</details>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">ccExpDate</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">ccHolder</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">ccNumberEnding</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">ccType</span>
<span class="gql-type-tag">Int</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">created</span>
<span class="gql-type-tag">DateTime!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">cycle</span>
<span class="gql-type-tag">Int</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">cycleStatus</span>
<span class="gql-type-tag">Int</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">label</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">lastUpdated</span>
<span class="gql-type-tag">DateTime!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">live</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">paymentMethod</span>
<span class="gql-type-tag">Int</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">publicId</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">tokenId</span>
<span class="gql-type-tag">String</span>
</div>
</li>
</ul>
</div>
</details>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">place</span>
<span class="gql-type-tag">DateTime</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">publicId</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">rejectedMessage</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li>
<details class="gql-nested-type">
<summary>
<span class="gql-field-name">shippingAddress</span>
<a class="gql-type-tag" href="graphql-type-AddressType">AddressType</a>
<span class="gql-show-fields">Show fields</span>
</summary>
<div class="gql-nested-content">
<div class="gql-nested-type-heading">AddressType fields</div>
<ul class="gql-field-list">
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">address</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">address2</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">city</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">companyName</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">countryCode</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">created</span>
<span class="gql-type-tag">DateTime!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">fax</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">firstName</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">label</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">lastName</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">live</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">phone</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">priceCode</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">publicId</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">stateProvinceCode</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">tokenId</span>
<span class="gql-type-tag">String</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">zipPostalCode</span>
<span class="gql-type-tag">String!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
</ul>
</div>
</details>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">shippingTotal</span>
<span class="gql-type-tag">Decimal!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">status</span>
<span class="gql-type-tag">Int!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">subTotal</span>
<span class="gql-type-tag">Decimal!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">taxTotal</span>
<span class="gql-type-tag">Decimal!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">total</span>
<span class="gql-type-tag">Decimal!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">tries</span>
<span class="gql-type-tag">Int!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">updated</span>
<span class="gql-type-tag">DateTime</span>
</div>
</li>
</ul>
</div>
</details>
</li>
</ul>
</div>
</details>
</li>
<li>
<details class="gql-nested-type">
<summary>
<span class="gql-field-name">pageInfo</span>
<span class="gql-type-tag">PageInfo!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
<span class="gql-show-fields">Show fields</span>
</summary>
<div class="gql-nested-content">
<div class="gql-nested-type-heading">PageInfo fields</div>
<ul class="gql-field-list">
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">endCursor</span>
<span class="gql-type-tag">String</span>
</div>
<div class="gql-field-desc">When paginating forwards, the cursor to continue.</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">hasNextPage</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
<div class="gql-field-desc">When paginating forwards, are there more items?</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">hasPreviousPage</span>
<span class="gql-type-tag">Boolean!</span>
<span class="gql-badge gql-badge-non-null">Non-null</span>
</div>
<div class="gql-field-desc">When paginating backwards, are there more items?</div>
</li>
<li class="gql-field-item">
<div class="gql-field-row">
<span class="gql-field-name">startCursor</span>
<span class="gql-type-tag">String</span>
</div>
<div class="gql-field-desc">When paginating backwards, the cursor to continue.</div>
</li>
</ul>
</div>
</details>
</li>
</ul>
    </div>

    <div class="gql-sidebar">
      <div class="gql-sidebar-inner">
<div class="gql-examples">
<input type="radio" class="gql-ex-select" name="exsel-orders" id="exsel-orders-0" checked>
<label class="gql-ex-select-label" for="exsel-orders-0">List recent orders for a customer</label>
<input type="radio" class="gql-ex-select" name="exsel-orders" id="exsel-orders-1">
<label class="gql-ex-select-label" for="exsel-orders-1">List orders with pagination</label>
<input type="radio" class="gql-ex-select" name="exsel-orders" id="exsel-orders-2">
<label class="gql-ex-select-label" for="exsel-orders-2">Get subscription details by customer</label>
<input type="radio" class="gql-ex-select" name="exsel-orders" id="exsel-orders-3">
<label class="gql-ex-select-label" for="exsel-orders-3">Get subscription details by subscription</label>
<div class="gql-example">
<p class="gql-example-desc">Retrieve a customer&#x27;s order history with basic info</p>
<div class="gql-example-tabs">
<input type="radio" name="ex-orders-0" id="ex-orders-0-0" checked>
<label for="ex-orders-0-0">GraphQL</label>
<input type="radio" name="ex-orders-0" id="ex-orders-0-1">
<label for="ex-orders-0-1">cURL</label>
<input type="radio" name="ex-orders-0" id="ex-orders-0-2">
<label for="ex-orders-0-2">Node.js</label>
<input type="radio" name="ex-orders-0" id="ex-orders-0-3">
<label for="ex-orders-0-3">Python</label>
<div class="gql-example-panel"><pre><code><span class="kw">query</span> {
  orders(customer: <span class="st">&quot;cust123&quot;</span>, first: <span class="nu">10</span>) {
    edges {
      node {
        publicId
        status
        subTotal
        total
        place
        created
        items {
          nodes {
            quantity
            product {
              name
              externalProductId
            }
          }
        }
      }
    }
  }
}</code></pre></div>
<div class="gql-example-panel"><pre><code><span class="kw">curl</span> -X POST https://restapi.ordergroove.com/graphql/<span class="nu">2026</span>-<span class="nu">01</span>/ \
  -H <span class="st">&quot;X-API-KEY: &lt;your-api-key&gt;&quot;</span> \
  -H <span class="st">&quot;Content-Type: application/json&quot;</span> \
  -d <span class="st">&#x27;{&quot;query&quot;: &quot;query { orders(customer: \&quot;cust123\&quot;, first: 10) { edges { node { publicId status subTotal total place created items { nodes { quantity product { name externalProductId } } } } } } }&quot;}&#x27;</span></code></pre></div>
<div class="gql-example-panel"><pre><code><span class="kw">const</span> query = <span class="st">`
query {
  orders(customer: &quot;cust123&quot;, first: 10) {
    edges {
      node {
        publicId
        status
        subTotal
        total
        place
        created
        items {
          nodes {
            quantity
            product {
              name
              externalProductId
            }
          }
        }
      }
    }
  }
}
`</span>;

<span class="kw">const</span> response = <span class="kw">await</span> fetch(
  <span class="st">&quot;https://restapi.ordergroove.com/graphql/2026-01/&quot;</span>,
  {
    method: <span class="st">&quot;POST&quot;</span>,
    headers: {
      <span class="st">&quot;X-API-KEY: &lt;your-api-key&gt;&quot;</span>,
      <span class="st">&quot;Content-Type&quot;</span>: <span class="st">&quot;application/json&quot;</span>,
    },
    body: JSON.stringify({ query }),
  }
);

<span class="kw">const</span> data = <span class="kw">await</span> response.json();</code></pre></div>
<div class="gql-example-panel"><pre><code><span class="kw">import</span> requests

query = <span class="st">&quot;&quot;&quot;
query {
  orders(customer: &quot;cust123&quot;, first: 10) {
    edges {
      node {
        publicId
        status
        subTotal
        total
        place
        created
        items {
          nodes {
            quantity
            product {
              name
              externalProductId
            }
          }
        }
      }
    }
  }
}
&quot;&quot;&quot;</span>

response = requests.post(
    <span class="st">&quot;https://restapi.ordergroove.com/graphql/2026-01/&quot;</span>,
    headers={
        <span class="st">&quot;X-API-KEY: &lt;your-api-key&gt;&quot;</span>,
        <span class="st">&quot;Content-Type&quot;</span>: <span class="st">&quot;application/json&quot;</span>,
    },
    json={<span class="st">&quot;query&quot;</span>: query},
)

data = response.json()</code></pre></div>
</div>
</div>
<div class="gql-example">
<p class="gql-example-desc">Page through a customer&#x27;s orders using cursor-based pagination</p>
<div class="gql-example-tabs">
<input type="radio" name="ex-orders-1" id="ex-orders-1-0" checked>
<label for="ex-orders-1-0">GraphQL</label>
<input type="radio" name="ex-orders-1" id="ex-orders-1-1">
<label for="ex-orders-1-1">cURL</label>
<input type="radio" name="ex-orders-1" id="ex-orders-1-2">
<label for="ex-orders-1-2">Node.js</label>
<input type="radio" name="ex-orders-1" id="ex-orders-1-3">
<label for="ex-orders-1-3">Python</label>
<div class="gql-example-panel"><pre><code><span class="kw">query</span> {
  orders(customer: <span class="st">&quot;cust123&quot;</span>, first: <span class="nu">10</span>, after: <span class="st">&quot;cursor123&quot;</span>) {
    edges {
      cursor
      node {
        publicId
        status
        subTotal
        total
        place
        created
      }
    }
    pageInfo {
      hasNextPage
      hasPreviousPage
      startCursor
      endCursor
    }
  }
}</code></pre></div>
<div class="gql-example-panel"><pre><code><span class="kw">curl</span> -X POST https://restapi.ordergroove.com/graphql/<span class="nu">2026</span>-<span class="nu">01</span>/ \
  -H <span class="st">&quot;X-API-KEY: &lt;your-api-key&gt;&quot;</span> \
  -H <span class="st">&quot;Content-Type: application/json&quot;</span> \
  -d <span class="st">&#x27;{&quot;query&quot;: &quot;query { orders(customer: \&quot;cust123\&quot;, first: 10, after: \&quot;cursor123\&quot;) { edges { cursor node { publicId status subTotal total place created } } pageInfo { hasNextPage hasPreviousPage startCursor endCursor } } }&quot;}&#x27;</span></code></pre></div>
<div class="gql-example-panel"><pre><code><span class="kw">const</span> query = <span class="st">`
query {
  orders(customer: &quot;cust123&quot;, first: 10, after: &quot;cursor123&quot;) {
    edges {
      cursor
      node {
        publicId
        status
        subTotal
        total
        place
        created
      }
    }
    pageInfo {
      hasNextPage
      hasPreviousPage
      startCursor
      endCursor
    }
  }
}
`</span>;

<span class="kw">const</span> response = <span class="kw">await</span> fetch(
  <span class="st">&quot;https://restapi.ordergroove.com/graphql/2026-01/&quot;</span>,
  {
    method: <span class="st">&quot;POST&quot;</span>,
    headers: {
      <span class="st">&quot;X-API-KEY: &lt;your-api-key&gt;&quot;</span>,
      <span class="st">&quot;Content-Type&quot;</span>: <span class="st">&quot;application/json&quot;</span>,
    },
    body: JSON.stringify({ query }),
  }
);

<span class="kw">const</span> data = <span class="kw">await</span> response.json();</code></pre></div>
<div class="gql-example-panel"><pre><code><span class="kw">import</span> requests

query = <span class="st">&quot;&quot;&quot;
query {
  orders(customer: &quot;cust123&quot;, first: 10, after: &quot;cursor123&quot;) {
    edges {
      cursor
      node {
        publicId
        status
        subTotal
        total
        place
        created
      }
    }
    pageInfo {
      hasNextPage
      hasPreviousPage
      startCursor
      endCursor
    }
  }
}
&quot;&quot;&quot;</span>

response = requests.post(
    <span class="st">&quot;https://restapi.ordergroove.com/graphql/2026-01/&quot;</span>,
    headers={
        <span class="st">&quot;X-API-KEY: &lt;your-api-key&gt;&quot;</span>,
        <span class="st">&quot;Content-Type&quot;</span>: <span class="st">&quot;application/json&quot;</span>,
    },
    json={<span class="st">&quot;query&quot;</span>: query},
)

data = response.json()</code></pre></div>
</div>
</div>
<div class="gql-example">
<p class="gql-example-desc">Detailed orders by customer</p>
<div class="gql-example-tabs">
<input type="radio" name="ex-orders-2" id="ex-orders-2-0" checked>
<label for="ex-orders-2-0">GraphQL</label>
<input type="radio" name="ex-orders-2" id="ex-orders-2-1">
<label for="ex-orders-2-1">cURL</label>
<input type="radio" name="ex-orders-2" id="ex-orders-2-2">
<label for="ex-orders-2-2">Node.js</label>
<input type="radio" name="ex-orders-2" id="ex-orders-2-3">
<label for="ex-orders-2-3">Python</label>
<div class="gql-example-panel"><pre><code><span class="kw">query</span> {
  orders(customer: <span class="st">&quot;cust123&quot;</span>, first: <span class="nu">25</span>) {
    edges {
      node {
        publicId
        status
        subTotal
        total
        place
        items {
          nodes {
            publicId
            quantity
            price
            totalPrice
            product {
              name
              externalProductId
              sku
            }
            <span class="kw">subscription</span> {
              publicId
              every
              everyPeriod
            }
          }
        }
      }
    }
  }
}</code></pre></div>
<div class="gql-example-panel"><pre><code><span class="kw">curl</span> -X POST https://restapi.ordergroove.com/graphql/<span class="nu">2026</span>-<span class="nu">01</span>/ \
  -H <span class="st">&quot;X-API-KEY: &lt;your-api-key&gt;&quot;</span> \
  -H <span class="st">&quot;Content-Type: application/json&quot;</span> \
  -d <span class="st">&#x27;{&quot;query&quot;: &quot;query { orders(customer: \&quot;cust123\&quot;, first: 25) { edges { node { publicId status subTotal total place items { nodes { publicId quantity price totalPrice product { name externalProductId sku } subscription { publicId every everyPeriod } } } } } } }&quot;}&#x27;</span></code></pre></div>
<div class="gql-example-panel"><pre><code><span class="kw">const</span> query = <span class="st">`
query {
  orders(customer: &quot;cust123&quot;, first: 25) {
    edges {
      node {
        publicId
        status
        subTotal
        total
        place
        items {
          nodes {
            publicId
            quantity
            price
            totalPrice
            product {
              name
              externalProductId
              sku
            }
            subscription {
              publicId
              every
              everyPeriod
            }
          }
        }
      }
    }
  }
}
`</span>;

<span class="kw">const</span> response = <span class="kw">await</span> fetch(
  <span class="st">&quot;https://restapi.ordergroove.com/graphql/2026-01/&quot;</span>,
  {
    method: <span class="st">&quot;POST&quot;</span>,
    headers: {
      <span class="st">&quot;X-API-KEY: &lt;your-api-key&gt;&quot;</span>,
      <span class="st">&quot;Content-Type&quot;</span>: <span class="st">&quot;application/json&quot;</span>,
    },
    body: JSON.stringify({ query }),
  }
);

<span class="kw">const</span> data = <span class="kw">await</span> response.json();</code></pre></div>
<div class="gql-example-panel"><pre><code><span class="kw">import</span> requests

query = <span class="st">&quot;&quot;&quot;
query {
  orders(customer: &quot;cust123&quot;, first: 25) {
    edges {
      node {
        publicId
        status
        subTotal
        total
        place
        items {
          nodes {
            publicId
            quantity
            price
            totalPrice
            product {
              name
              externalProductId
              sku
            }
            subscription {
              publicId
              every
              everyPeriod
            }
          }
        }
      }
    }
  }
}
&quot;&quot;&quot;</span>

response = requests.post(
    <span class="st">&quot;https://restapi.ordergroove.com/graphql/2026-01/&quot;</span>,
    headers={
        <span class="st">&quot;X-API-KEY: &lt;your-api-key&gt;&quot;</span>,
        <span class="st">&quot;Content-Type&quot;</span>: <span class="st">&quot;application/json&quot;</span>,
    },
    json={<span class="st">&quot;query&quot;</span>: query},
)

data = response.json()</code></pre></div>
</div>
</div>
<div class="gql-example">
<p class="gql-example-desc">Retrieve orders for a specific subscription with line item details</p>
<div class="gql-example-tabs">
<input type="radio" name="ex-orders-3" id="ex-orders-3-0" checked>
<label for="ex-orders-3-0">GraphQL</label>
<input type="radio" name="ex-orders-3" id="ex-orders-3-1">
<label for="ex-orders-3-1">cURL</label>
<input type="radio" name="ex-orders-3" id="ex-orders-3-2">
<label for="ex-orders-3-2">Node.js</label>
<input type="radio" name="ex-orders-3" id="ex-orders-3-3">
<label for="ex-orders-3-3">Python</label>
<div class="gql-example-panel"><pre><code><span class="kw">query</span> {
  orders(<span class="kw">subscription</span>: <span class="st">&quot;sub123&quot;</span>, first: <span class="nu">25</span>) {
    edges {
      node {
        publicId
        status
        subTotal
        total
        place
        created
        items {
          nodes {
            publicId
            quantity
            price
            totalPrice
            product {
              name
              externalProductId
              sku
            }
            <span class="kw">subscription</span> {
              publicId
              every
              everyPeriod
            }
          }
        }
      }
    }
  }
}</code></pre></div>
<div class="gql-example-panel"><pre><code><span class="kw">curl</span> -X POST https://restapi.ordergroove.com/graphql/<span class="nu">2026</span>-<span class="nu">01</span>/ \
  -H <span class="st">&quot;X-API-KEY: &lt;your-api-key&gt;&quot;</span> \
  -H <span class="st">&quot;Content-Type: application/json&quot;</span> \
  -d <span class="st">&#x27;{&quot;query&quot;: &quot;query { orders(subscription: \&quot;sub123\&quot;, first: 25) { edges { node { publicId status subTotal total place created items { nodes { publicId quantity price totalPrice product { name externalProductId sku } subscription { publicId every everyPeriod } } } } } } }&quot;}&#x27;</span></code></pre></div>
<div class="gql-example-panel"><pre><code><span class="kw">const</span> query = <span class="st">`
query {
  orders(subscription: &quot;sub123&quot;, first: 25) {
    edges {
      node {
        publicId
        status
        subTotal
        total
        place
        created
        items {
          nodes {
            publicId
            quantity
            price
            totalPrice
            product {
              name
              externalProductId
              sku
            }
            subscription {
              publicId
              every
              everyPeriod
            }
          }
        }
      }
    }
  }
}
`</span>;

<span class="kw">const</span> response = <span class="kw">await</span> fetch(
  <span class="st">&quot;https://restapi.ordergroove.com/graphql/2026-01/&quot;</span>,
  {
    method: <span class="st">&quot;POST&quot;</span>,
    headers: {
      <span class="st">&quot;X-API-KEY: &lt;your-api-key&gt;&quot;</span>,
      <span class="st">&quot;Content-Type&quot;</span>: <span class="st">&quot;application/json&quot;</span>,
    },
    body: JSON.stringify({ query }),
  }
);

<span class="kw">const</span> data = <span class="kw">await</span> response.json();</code></pre></div>
<div class="gql-example-panel"><pre><code><span class="kw">import</span> requests

query = <span class="st">&quot;&quot;&quot;
query {
  orders(subscription: &quot;sub123&quot;, first: 25) {
    edges {
      node {
        publicId
        status
        subTotal
        total
        place
        created
        items {
          nodes {
            publicId
            quantity
            price
            totalPrice
            product {
              name
              externalProductId
              sku
            }
            subscription {
              publicId
              every
              everyPeriod
            }
          }
        }
      }
    }
  }
}
&quot;&quot;&quot;</span>

response = requests.post(
    <span class="st">&quot;https://restapi.ordergroove.com/graphql/2026-01/&quot;</span>,
    headers={
        <span class="st">&quot;X-API-KEY: &lt;your-api-key&gt;&quot;</span>,
        <span class="st">&quot;Content-Type&quot;</span>: <span class="st">&quot;application/json&quot;</span>,
    },
    json={<span class="st">&quot;query&quot;</span>: query},
)

data = response.json()</code></pre></div>
</div>
</div>
</div>
      </div>
    </div>

  </div>

</div></div></div></div></main><footer aria-label="Status banner" class="Footer2U8XAPoGhlgO AppFooter rm-Banners"></footer><div class="ModalWrapper" id="ChatGPT-modal"></div></div><div class="ContentWithOwlbot-sidebar1cgUrK3uYZLh rm-AskAi-sidebar"></div></div></div><div class="ModalWrapper" id="tutorialmodal-root"></div></div></div><div class="ng-non-bindable"><script id="ssr-props" type="application/json">{"sidebars":{},"apiBaseUrl":"/","baseUrl":"/","search":{"appId":"T28YKFATPY","searchApiKey":"ZTA4NzdmYTRkODc1N2JjZTM4NzgxZDQ0OWVlYzFkOTdlNjM4ODdjZTY5YWMxMDA4ZjliM2ZiZDg4MTNhODVmY3RhZ0ZpbHRlcnM9KHByb2plY3Q6NWQ2M2RhYmVjYzAzNDcwMDU2ZjljNTcwKSwodmVyc2lvbjpub25lLHZlcnNpb246NjU0MTIwNTM3N2IyMTkwYTE1NTI3YTlmKSwoaGlkZGVuOm5vbmUsaGlkZGVuOmZhbHNlKSwoaW5kZXg6Q3VzdG9tUGFnZSxpbmRleDpQYWdlKQ==","indexName":"readme_search_v2","projectsMeta":[{"modules":{"logs":false,"suggested_edits":false,"discuss":false,"changelog":false,"reference":true,"examples":true,"docs":true,"landing":false,"custompages":false,"tutorials":false,"graphql":false},"id":"5d63dabecc03470056f9c570","name":"Ordergroove API Reference","subdomain":"og-restrpc","subpath":"","nav_names":{"discuss":"","changelog":"","reference":"","docs":"","tutorials":"","recipes":""}}],"urlManagerOpts":{"lang":"en","parent":{"childrenProjects":[]},"project":{"subdomain":"og-restrpc"},"version":"2.10.0"}},"document":{"renderable":{"status":false,"error":"Unexpected character `!` (U+0021) before name, expected a character that can start a name, such as a letter, `$`, or `_` (note: to create a comment in MDX, use `{/* text */}`)","message":null},"slug":"graphql-orders","title":"Orders","updated_at":"2026-02-25T22:15:42.000Z","uri":"/branches/2.10.0/custom_pages/graphql-orders","appearance":{"fullscreen":false},"content":{"body":"\n\u003c!-- requires graphql-docs.css in README.io Appearance > Custom CSS -->\n\u003cdiv class=\"gql-docs\">\n\n  \u003cdiv class=\"gql-layout\">\n\n\u003cnav class=\"gql-nav\">\n\u003cdiv class=\"gql-nav-inner\">\n\u003cdetails class=\"gql-nav-section\" open>\n\u003csummary>Queries\u003c/summary>\n\u003cul class=\"gql-nav-list\">\n\u003cli>\u003ca class=\"gql-nav-link\" href=\"graphql-order\">order\u003c/a>\u003c/li>\n\u003cli>\u003cspan class=\"gql-nav-link gql-nav-active\">orders\u003c/span>\u003c/li>\n\u003cli>\u003ca class=\"gql-nav-link\" href=\"graphql-subscription\">subscription\u003c/a>\u003c/li>\n\u003cli>\u003ca class=\"gql-nav-link\" href=\"graphql-subscriptions\">subscriptions\u003c/a>\u003c/li>\n\u003c/ul>\n\u003c/details>\n\u003cdetails class=\"gql-nav-section\" open>\n\u003csummary>Objects\u003c/summary>\n\u003cul class=\"gql-nav-list\">\n\u003cli>\u003ca class=\"gql-nav-link\" href=\"graphql-type-AddressType\">Address\u003c/a>\u003c/li>\n\u003cli>\u003ca class=\"gql-nav-link\" href=\"graphql-type-BaseIncentiveType\">BaseIncentive\u003c/a>\u003c/li>\n\u003cli>\u003ca class=\"gql-nav-link\" href=\"graphql-type-CancelReasonType\">CancelReason\u003c/a>\u003c/li>\n\u003cli>\u003ca class=\"gql-nav-link\" href=\"graphql-type-ComponentType\">Component\u003c/a>\u003c/li>\n\u003cli>\u003ca class=\"gql-nav-link\" href=\"graphql-type-CustomerType\">Customer\u003c/a>\u003c/li>\n\u003cli>\u003ca class=\"gql-nav-link\" href=\"graphql-type-DiscountIncentiveType\">DiscountIncentive\u003c/a>\u003c/li>\n\u003cli>\u003ca class=\"gql-nav-link\" href=\"graphql-type-FreeTrialSubscriptionContextType\">FreeTrialSubscriptionContext\u003c/a>\u003c/li>\n\u003cli>\u003ca class=\"gql-nav-link\" href=\"graphql-type-GiftIncentiveType\">GiftIncentive\u003c/a>\u003c/li>\n\u003cli>\u003ca class=\"gql-nav-link\" href=\"graphql-type-GranteeType\">Grantee\u003c/a>\u003c/li>\n\u003cli>\u003ca class=\"gql-nav-link\" href=\"graphql-type-IncentiveType\">Incentive\u003c/a>\u003c/li>\n\u003cli>\u003ca class=\"gql-nav-link\" href=\"graphql-type-ItemType\">Item\u003c/a>\u003c/li>\n\u003cli>\u003ca class=\"gql-nav-link\" href=\"graphql-type-ItemsPage\">ItemsPage\u003c/a>\u003c/li>\n\u003cli>\u003ca class=\"gql-nav-link\" href=\"graphql-type-OneTimeIncentiveType\">OneTimeIncentive\u003c/a>\u003c/li>\n\u003cli>\u003ca class=\"gql-nav-link\" href=\"graphql-type-OrderConnection\">OrderConnection\u003c/a>\u003c/li>\n\u003cli>\u003ca class=\"gql-nav-link\" href=\"graphql-type-OrderEdge\">OrderEdge\u003c/a>\u003c/li>\n\u003cli>\u003ca class=\"gql-nav-link\" href=\"graphql-type-OrderType\">Order\u003c/a>\u003c/li>\n\u003cli>\u003ca class=\"gql-nav-link\" href=\"graphql-type-PaymentType\">Payment\u003c/a>\u003c/li>\n\u003cli>\u003ca class=\"gql-nav-link\" href=\"graphql-type-PrepaidSubscriptionContextType\">PrepaidSubscriptionContext\u003c/a>\u003c/li>\n\u003cli>\u003ca class=\"gql-nav-link\" href=\"graphql-type-ProductGroupType\">ProductGroup\u003c/a>\u003c/li>\n\u003cli>\u003ca class=\"gql-nav-link\" href=\"graphql-type-ProductType\">Product\u003c/a>\u003c/li>\n\u003cli>\u003ca class=\"gql-nav-link\" href=\"graphql-type-QueuedActionType\">QueuedAction\u003c/a>\u003c/li>\n\u003cli>\u003ca class=\"gql-nav-link\" href=\"graphql-type-SubscriptionConnection\">SubscriptionConnection\u003c/a>\u003c/li>\n\u003cli>\u003ca class=\"gql-nav-link\" href=\"graphql-type-SubscriptionEdge\">SubscriptionEdge\u003c/a>\u003c/li>\n\u003cli>\u003ca class=\"gql-nav-link\" href=\"graphql-type-SubscriptionType\">Subscription\u003c/a>\u003c/li>\n\u003c/ul>\n\u003c/details>\n\u003c/div>\n\u003c/nav>\n\n    \u003cdiv class=\"gql-main\">\n\u003ch2 class=\"gql-section-heading\">Arguments\u003c/h2>\n\u003cul class=\"gql-arg-list\">\n\u003cli class=\"gql-arg-item\">\n\u003cdiv class=\"gql-arg-header\">\n\u003cspan class=\"gql-arg-name\">after\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003cdiv class=\"gql-arg-desc\">Cursor to paginate forward from.\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-arg-item\">\n\u003cdiv class=\"gql-arg-header\">\n\u003cspan class=\"gql-arg-name\">before\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003cdiv class=\"gql-arg-desc\">Cursor to paginate backward from.\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-arg-item\">\n\u003cdiv class=\"gql-arg-header\">\n\u003cspan class=\"gql-arg-name\">customer\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003cdiv class=\"gql-arg-desc\">Filter by customer ID.\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-arg-item\">\n\u003cdiv class=\"gql-arg-header\">\n\u003cspan class=\"gql-arg-name\">first\u003c/span>\n\u003cspan class=\"gql-type-tag\">Int\u003c/span>\n\u003c/div>\n\u003cdiv class=\"gql-arg-desc\">Return the first N results.\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-arg-item\">\n\u003cdiv class=\"gql-arg-header\">\n\u003cspan class=\"gql-arg-name\">includePrepaidOrders\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean\u003c/span>\n\u003c/div>\n\u003cdiv class=\"gql-arg-desc\">Include prepaid orders in results. Defaults to true.\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-arg-item\">\n\u003cdiv class=\"gql-arg-header\">\n\u003cspan class=\"gql-arg-name\">last\u003c/span>\n\u003cspan class=\"gql-type-tag\">Int\u003c/span>\n\u003c/div>\n\u003cdiv class=\"gql-arg-desc\">Return the last N results.\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-arg-item\">\n\u003cdiv class=\"gql-arg-header\">\n\u003cspan class=\"gql-arg-name\">place\u003c/span>\n\u003cspan class=\"gql-type-tag\">Date\u003c/span>\n\u003c/div>\n\u003cdiv class=\"gql-arg-desc\">Filter by exact placement date (YYYY-MM-DD).\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-arg-item\">\n\u003cdiv class=\"gql-arg-header\">\n\u003cspan class=\"gql-arg-name\">placeEnd\u003c/span>\n\u003cspan class=\"gql-type-tag\">Date\u003c/span>\n\u003c/div>\n\u003cdiv class=\"gql-arg-desc\">Filter orders placed on or before this date (YYYY-MM-DD).\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-arg-item\">\n\u003cdiv class=\"gql-arg-header\">\n\u003cspan class=\"gql-arg-name\">placeStart\u003c/span>\n\u003cspan class=\"gql-type-tag\">Date\u003c/span>\n\u003c/div>\n\u003cdiv class=\"gql-arg-desc\">Filter orders placed on or after this date (YYYY-MM-DD).\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-arg-item\">\n\u003cdiv class=\"gql-arg-header\">\n\u003cspan class=\"gql-arg-name\">status\u003c/span>\n\u003cspan class=\"gql-type-tag\">[Int!]\u003c/span>\n\u003c/div>\n\u003cdiv class=\"gql-arg-desc\">Filter by order status codes.\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-arg-item\">\n\u003cdiv class=\"gql-arg-header\">\n\u003cspan class=\"gql-arg-name\">subscription\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003cdiv class=\"gql-arg-desc\">Filter by subscription public ID.\u003c/div>\n\u003c/li>\n\u003c/ul>\n\u003ch2 class=\"gql-section-heading\">Return type: OrderConnection\u003c/h2>\n\u003cul class=\"gql-field-list\">\n\u003cli>\n\u003cdetails class=\"gql-nested-type\">\n\u003csummary>\n\u003cspan class=\"gql-field-name\">edges\u003c/span>\n\u003ca class=\"gql-type-tag\" href=\"graphql-type-OrderEdge\">[OrderEdge!]!\u003c/a>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003cspan class=\"gql-show-fields\">Show fields\u003c/span>\n\u003c/summary>\n\u003cdiv class=\"gql-nested-content\">\n\u003cdiv class=\"gql-nested-type-heading\">OrderEdge fields\u003c/div>\n\u003cul class=\"gql-field-list\">\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">cursor\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli>\n\u003cdetails class=\"gql-nested-type\">\n\u003csummary>\n\u003cspan class=\"gql-field-name\">node\u003c/span>\n\u003ca class=\"gql-type-tag\" href=\"graphql-type-OrderType\">OrderType!\u003c/a>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003cspan class=\"gql-show-fields\">Show fields\u003c/span>\n\u003c/summary>\n\u003cdiv class=\"gql-nested-content\">\n\u003cdiv class=\"gql-nested-type-heading\">OrderType fields\u003c/div>\n\u003cul class=\"gql-field-list\">\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">cancelled\u003c/span>\n\u003cspan class=\"gql-type-tag\">DateTime\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">created\u003c/span>\n\u003cspan class=\"gql-type-tag\">DateTime\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">currencyCode\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli>\n\u003cdetails class=\"gql-nested-type\">\n\u003csummary>\n\u003cspan class=\"gql-field-name\">customer\u003c/span>\n\u003ca class=\"gql-type-tag\" href=\"graphql-type-CustomerType\">CustomerType\u003c/a>\n\u003cspan class=\"gql-show-fields\">Show fields\u003c/span>\n\u003c/summary>\n\u003cdiv class=\"gql-nested-content\">\n\u003cdiv class=\"gql-nested-type-heading\">CustomerType fields\u003c/div>\n\u003cul class=\"gql-field-list\">\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">created\u003c/span>\n\u003cspan class=\"gql-type-tag\">DateTime!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">email\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">extraData\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">firstName\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">lastName\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">lastUpdated\u003c/span>\n\u003cspan class=\"gql-type-tag\">DateTime!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">live\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">locale\u003c/span>\n\u003cspan class=\"gql-type-tag\">Int\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">merchantUserId\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">phoneNumber\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">phoneType\u003c/span>\n\u003cspan class=\"gql-type-tag\">Int\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">priceCode\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003c/ul>\n\u003c/div>\n\u003c/details>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">discountTotal\u003c/span>\n\u003cspan class=\"gql-type-tag\">Decimal!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">extraData\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">genericErrorCount\u003c/span>\n\u003cspan class=\"gql-type-tag\">Int!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">hasPlan\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli>\n\u003cdetails class=\"gql-nested-type\">\n\u003csummary>\n\u003cspan class=\"gql-field-name\">items\u003c/span>\n\u003ca class=\"gql-type-tag\" href=\"graphql-type-ItemsPage\">ItemsPage!\u003c/a>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003cspan class=\"gql-show-fields\">Show fields\u003c/span>\n\u003c/summary>\n\u003cdiv class=\"gql-nested-content\">\n\u003cdiv class=\"gql-nested-type-heading\">ItemsPage fields\u003c/div>\n\u003cul class=\"gql-field-list\">\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">hasMore\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli>\n\u003cdetails class=\"gql-nested-type\">\n\u003csummary>\n\u003cspan class=\"gql-field-name\">nodes\u003c/span>\n\u003ca class=\"gql-type-tag\" href=\"graphql-type-ItemType\">[ItemType!]!\u003c/a>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003cspan class=\"gql-show-fields\">Show fields\u003c/span>\n\u003c/summary>\n\u003cdiv class=\"gql-nested-content\">\n\u003cdiv class=\"gql-nested-type-heading\">ItemType fields\u003c/div>\n\u003cul class=\"gql-field-list\">\n\u003cli>\n\u003cdetails class=\"gql-nested-type\">\n\u003csummary>\n\u003cspan class=\"gql-field-name\">components\u003c/span>\n\u003ca class=\"gql-type-tag\" href=\"graphql-type-ProductType\">[ProductType!]!\u003c/a>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003cspan class=\"gql-show-fields\">Show fields\u003c/span>\n\u003c/summary>\n\u003cdiv class=\"gql-nested-content\">\n\u003cdiv class=\"gql-nested-type-heading\">ProductType fields\u003c/div>\n\u003cul class=\"gql-field-list\">\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">autoshipByDefault\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">autoshipEnabled\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">created\u003c/span>\n\u003cspan class=\"gql-type-tag\">DateTime\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">detailUrl\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">discontinued\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">every\u003c/span>\n\u003cspan class=\"gql-type-tag\">Int\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">everyPeriod\u003c/span>\n\u003cspan class=\"gql-type-tag\">Int\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">externalProductId\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">extraData\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli>\n\u003cdetails class=\"gql-nested-type\">\n\u003csummary>\n\u003cspan class=\"gql-field-name\">groups\u003c/span>\n\u003ca class=\"gql-type-tag\" href=\"graphql-type-ProductGroupType\">[ProductGroupType!]!\u003c/a>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003cspan class=\"gql-show-fields\">Show fields\u003c/span>\n\u003c/summary>\n\u003cdiv class=\"gql-nested-content\">\n\u003cdiv class=\"gql-nested-type-heading\">ProductGroupType fields\u003c/div>\n\u003cul class=\"gql-field-list\">\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">groupType\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">name\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003c/ul>\n\u003c/div>\n\u003c/details>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">imageUrl\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">lastUpdate\u003c/span>\n\u003cspan class=\"gql-type-tag\">DateTime\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">live\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">name\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">prepaidEligible\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">price\u003c/span>\n\u003cspan class=\"gql-type-tag\">Decimal!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">productType\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">sku\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003c/ul>\n\u003c/div>\n\u003c/details>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">extraCost\u003c/span>\n\u003cspan class=\"gql-type-tag\">Decimal!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">firstPlaced\u003c/span>\n\u003cspan class=\"gql-type-tag\">DateTime\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">frozen\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">offerPublicId\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">oneTime\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli>\n\u003cdetails class=\"gql-nested-type\">\n\u003csummary>\n\u003cspan class=\"gql-field-name\">oneTimeIncentives\u003c/span>\n\u003ca class=\"gql-type-tag\" href=\"graphql-type-OneTimeIncentiveType\">[OneTimeIncentiveType!]!\u003c/a>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003cspan class=\"gql-show-fields\">Show fields\u003c/span>\n\u003c/summary>\n\u003cdiv class=\"gql-nested-content\">\n\u003cdiv class=\"gql-nested-type-heading\">OneTimeIncentiveType fields\u003c/div>\n\u003cul class=\"gql-field-list\">\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">appliedAt\u003c/span>\n\u003cspan class=\"gql-type-tag\">DateTime\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">created\u003c/span>\n\u003cspan class=\"gql-type-tag\">DateTime!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">description\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">expires\u003c/span>\n\u003cspan class=\"gql-type-tag\">DateTime\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">externalCode\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli>\n\u003cdetails class=\"gql-nested-type\">\n\u003csummary>\n\u003cspan class=\"gql-field-name\">incentive\u003c/span>\n\u003ca class=\"gql-type-tag\" href=\"graphql-type-IncentiveType\">IncentiveType\u003c/a>\n\u003cspan class=\"gql-show-fields\">Show fields\u003c/span>\n\u003c/summary>\n\u003cdiv class=\"gql-nested-content\">\n\u003cdiv class=\"gql-nested-type-heading\">IncentiveType fields \u003cspan class=\"gql-badge gql-badge-interface\">Interface\u003c/span>\u003c/div>\n\u003cul class=\"gql-field-list\">\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">name\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">publicId\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003c/ul>\n\u003cdiv class=\"gql-implementations\">\n\u003cdiv class=\"gql-nested-type-heading\">Implemented by\u003c/div>\n\u003cul class=\"gql-impl-list\">\n\u003cli class=\"gql-impl-item\">\n\u003ca class=\"gql-impl-link\" href=\"graphql-type-BaseIncentiveType\">BaseIncentive\u003c/a>\n\u003c/li>\n\u003cli class=\"gql-impl-item\">\n\u003ca class=\"gql-impl-link\" href=\"graphql-type-DiscountIncentiveType\">DiscountIncentive\u003c/a>\n\u003cdiv class=\"gql-impl-fields\">discountType: String!, field: String!, limitPolicy: String, limitValue: Decimal, target: String!, thresholdField: String, thresholdValue: Decimal, value: Decimal!\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-impl-item\">\n\u003ca class=\"gql-impl-link\" href=\"graphql-type-GiftIncentiveType\">GiftIncentive\u003c/a>\n\u003cdiv class=\"gql-impl-fields\">product: ProductType, target: String!\u003c/div>\n\u003c/li>\n\u003c/ul>\n\u003c/div>\n\u003c/div>\n\u003c/details>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">lastUpdated\u003c/span>\n\u003cspan class=\"gql-type-tag\">DateTime!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">onetimeCouponType\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">publicId\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">stackingType\u003c/span>\n\u003cspan class=\"gql-type-tag\">Int!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003c/ul>\n\u003c/div>\n\u003c/details>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">orderPublicId\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">price\u003c/span>\n\u003cspan class=\"gql-type-tag\">Decimal!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli>\n\u003cdetails class=\"gql-nested-type\">\n\u003csummary>\n\u003cspan class=\"gql-field-name\">product\u003c/span>\n\u003ca class=\"gql-type-tag\" href=\"graphql-type-ProductType\">ProductType\u003c/a>\n\u003cspan class=\"gql-show-fields\">Show fields\u003c/span>\n\u003c/summary>\n\u003cdiv class=\"gql-nested-content\">\n\u003cdiv class=\"gql-nested-type-heading\">ProductType fields\u003c/div>\n\u003cul class=\"gql-field-list\">\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">autoshipByDefault\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">autoshipEnabled\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">created\u003c/span>\n\u003cspan class=\"gql-type-tag\">DateTime\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">detailUrl\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">discontinued\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">every\u003c/span>\n\u003cspan class=\"gql-type-tag\">Int\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">everyPeriod\u003c/span>\n\u003cspan class=\"gql-type-tag\">Int\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">externalProductId\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">extraData\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli>\n\u003cdetails class=\"gql-nested-type\">\n\u003csummary>\n\u003cspan class=\"gql-field-name\">groups\u003c/span>\n\u003ca class=\"gql-type-tag\" href=\"graphql-type-ProductGroupType\">[ProductGroupType!]!\u003c/a>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003cspan class=\"gql-show-fields\">Show fields\u003c/span>\n\u003c/summary>\n\u003cdiv class=\"gql-nested-content\">\n\u003cdiv class=\"gql-nested-type-heading\">ProductGroupType fields\u003c/div>\n\u003cul class=\"gql-field-list\">\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">groupType\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">name\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003c/ul>\n\u003c/div>\n\u003c/details>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">imageUrl\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">lastUpdate\u003c/span>\n\u003cspan class=\"gql-type-tag\">DateTime\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">live\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">name\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">prepaidEligible\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">price\u003c/span>\n\u003cspan class=\"gql-type-tag\">Decimal!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">productType\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">sku\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003c/ul>\n\u003c/div>\n\u003c/details>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">publicId\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">quantity\u003c/span>\n\u003cspan class=\"gql-type-tag\">Int!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli>\n\u003cdetails class=\"gql-nested-type\">\n\u003csummary>\n\u003cspan class=\"gql-field-name\">subscription\u003c/span>\n\u003ca class=\"gql-type-tag\" href=\"graphql-type-SubscriptionType\">SubscriptionType\u003c/a>\n\u003cspan class=\"gql-show-fields\">Show fields\u003c/span>\n\u003c/summary>\n\u003cdiv class=\"gql-nested-content\">\n\u003cdiv class=\"gql-nested-type-heading\">SubscriptionType fields\u003c/div>\n\u003cul class=\"gql-field-list\">\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">cancelReason\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli>\n\u003cdetails class=\"gql-nested-type\">\n\u003csummary>\n\u003cspan class=\"gql-field-name\">cancelReasonCode\u003c/span>\n\u003ca class=\"gql-type-tag\" href=\"graphql-type-CancelReasonType\">CancelReasonType\u003c/a>\n\u003cspan class=\"gql-show-fields\">Show fields\u003c/span>\n\u003c/summary>\n\u003cdiv class=\"gql-nested-content\">\n\u003cdiv class=\"gql-nested-type-heading\">CancelReasonType fields\u003c/div>\n\u003cul class=\"gql-field-list\">\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">code\u003c/span>\n\u003cspan class=\"gql-type-tag\">Int!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">reason\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003c/ul>\n\u003c/div>\n\u003c/details>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">cancelled\u003c/span>\n\u003cspan class=\"gql-type-tag\">DateTime\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli>\n\u003cdetails class=\"gql-nested-type\">\n\u003csummary>\n\u003cspan class=\"gql-field-name\">components\u003c/span>\n\u003ca class=\"gql-type-tag\" href=\"graphql-type-ComponentType\">[ComponentType!]\u003c/a>\n\u003cspan class=\"gql-show-fields\">Show fields\u003c/span>\n\u003c/summary>\n\u003cdiv class=\"gql-nested-content\">\n\u003cdiv class=\"gql-nested-type-heading\">ComponentType fields\u003c/div>\n\u003cul class=\"gql-field-list\">\n\u003cli>\n\u003cdetails class=\"gql-nested-type\">\n\u003csummary>\n\u003cspan class=\"gql-field-name\">product\u003c/span>\n\u003ca class=\"gql-type-tag\" href=\"graphql-type-ProductType\">ProductType\u003c/a>\n\u003cspan class=\"gql-show-fields\">Show fields\u003c/span>\n\u003c/summary>\n\u003cdiv class=\"gql-nested-content\">\n\u003cdiv class=\"gql-nested-type-heading\">ProductType fields\u003c/div>\n\u003cul class=\"gql-field-list\">\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">autoshipByDefault\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">autoshipEnabled\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">created\u003c/span>\n\u003cspan class=\"gql-type-tag\">DateTime\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">detailUrl\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">discontinued\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">every\u003c/span>\n\u003cspan class=\"gql-type-tag\">Int\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">everyPeriod\u003c/span>\n\u003cspan class=\"gql-type-tag\">Int\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">externalProductId\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">extraData\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli>\n\u003cdetails class=\"gql-nested-type\">\n\u003csummary>\n\u003cspan class=\"gql-field-name\">groups\u003c/span>\n\u003ca class=\"gql-type-tag\" href=\"graphql-type-ProductGroupType\">[ProductGroupType!]!\u003c/a>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003cspan class=\"gql-show-fields\">Show fields\u003c/span>\n\u003c/summary>\n\u003cdiv class=\"gql-nested-content\">\n\u003cdiv class=\"gql-nested-type-heading\">ProductGroupType fields\u003c/div>\n\u003cul class=\"gql-field-list\">\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">groupType\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">name\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003c/ul>\n\u003c/div>\n\u003c/details>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">imageUrl\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">lastUpdate\u003c/span>\n\u003cspan class=\"gql-type-tag\">DateTime\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">live\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">name\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">prepaidEligible\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">price\u003c/span>\n\u003cspan class=\"gql-type-tag\">Decimal!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">productType\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">sku\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003c/ul>\n\u003c/div>\n\u003c/details>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">publicId\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">quantity\u003c/span>\n\u003cspan class=\"gql-type-tag\">Int\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003c/ul>\n\u003c/div>\n\u003c/details>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">created\u003c/span>\n\u003cspan class=\"gql-type-tag\">DateTime\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">currencyCode\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli>\n\u003cdetails class=\"gql-nested-type\">\n\u003csummary>\n\u003cspan class=\"gql-field-name\">customer\u003c/span>\n\u003ca class=\"gql-type-tag\" href=\"graphql-type-CustomerType\">CustomerType\u003c/a>\n\u003cspan class=\"gql-show-fields\">Show fields\u003c/span>\n\u003c/summary>\n\u003cdiv class=\"gql-nested-content\">\n\u003cdiv class=\"gql-nested-type-heading\">CustomerType fields\u003c/div>\n\u003cul class=\"gql-field-list\">\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">created\u003c/span>\n\u003cspan class=\"gql-type-tag\">DateTime!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">email\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">extraData\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">firstName\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">lastName\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">lastUpdated\u003c/span>\n\u003cspan class=\"gql-type-tag\">DateTime!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">live\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">locale\u003c/span>\n\u003cspan class=\"gql-type-tag\">Int\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">merchantUserId\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">phoneNumber\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">phoneType\u003c/span>\n\u003cspan class=\"gql-type-tag\">Int\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">priceCode\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003c/ul>\n\u003c/div>\n\u003c/details>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">every\u003c/span>\n\u003cspan class=\"gql-type-tag\">Int\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">everyPeriod\u003c/span>\n\u003cspan class=\"gql-type-tag\">Int\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">externalId\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">extraData\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli>\n\u003cdetails class=\"gql-nested-type\">\n\u003csummary>\n\u003cspan class=\"gql-field-name\">freeTrialSubscriptionContext\u003c/span>\n\u003ca class=\"gql-type-tag\" href=\"graphql-type-FreeTrialSubscriptionContextType\">FreeTrialSubscriptionContextType\u003c/a>\n\u003cspan class=\"gql-show-fields\">Show fields\u003c/span>\n\u003c/summary>\n\u003cdiv class=\"gql-nested-content\">\n\u003cdiv class=\"gql-nested-type-heading\">FreeTrialSubscriptionContextType fields\u003c/div>\n\u003cul class=\"gql-field-list\">\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">conversionItem\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">days\u003c/span>\n\u003cspan class=\"gql-type-tag\">Int!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">expiration\u003c/span>\n\u003cspan class=\"gql-type-tag\">DateTime!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">isInFreeTrial\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli>\n\u003cdetails class=\"gql-nested-type\">\n\u003csummary>\n\u003cspan class=\"gql-field-name\">product\u003c/span>\n\u003ca class=\"gql-type-tag\" href=\"graphql-type-ProductType\">ProductType\u003c/a>\n\u003cspan class=\"gql-show-fields\">Show fields\u003c/span>\n\u003c/summary>\n\u003cdiv class=\"gql-nested-content\">\n\u003cdiv class=\"gql-nested-type-heading\">ProductType fields\u003c/div>\n\u003cul class=\"gql-field-list\">\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">autoshipByDefault\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">autoshipEnabled\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">created\u003c/span>\n\u003cspan class=\"gql-type-tag\">DateTime\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">detailUrl\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">discontinued\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">every\u003c/span>\n\u003cspan class=\"gql-type-tag\">Int\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">everyPeriod\u003c/span>\n\u003cspan class=\"gql-type-tag\">Int\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">externalProductId\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">extraData\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli>\n\u003cdetails class=\"gql-nested-type\">\n\u003csummary>\n\u003cspan class=\"gql-field-name\">groups\u003c/span>\n\u003ca class=\"gql-type-tag\" href=\"graphql-type-ProductGroupType\">[ProductGroupType!]!\u003c/a>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003cspan class=\"gql-show-fields\">Show fields\u003c/span>\n\u003c/summary>\n\u003cdiv class=\"gql-nested-content\">\n\u003cdiv class=\"gql-nested-type-heading\">ProductGroupType fields\u003c/div>\n\u003cul class=\"gql-field-list\">\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">groupType\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">name\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003c/ul>\n\u003c/div>\n\u003c/details>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">imageUrl\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">lastUpdate\u003c/span>\n\u003cspan class=\"gql-type-tag\">DateTime\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">live\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">name\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">prepaidEligible\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">price\u003c/span>\n\u003cspan class=\"gql-type-tag\">Decimal!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">productType\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">sku\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003c/ul>\n\u003c/div>\n\u003c/details>\n\u003c/li>\n\u003c/ul>\n\u003c/div>\n\u003c/details>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">frequencyDays\u003c/span>\n\u003cspan class=\"gql-type-tag\">Int\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli>\n\u003cdetails class=\"gql-nested-type\">\n\u003csummary>\n\u003cspan class=\"gql-field-name\">grantees\u003c/span>\n\u003ca class=\"gql-type-tag\" href=\"graphql-type-GranteeType\">[GranteeType!]!\u003c/a>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003cspan class=\"gql-show-fields\">Show fields\u003c/span>\n\u003c/summary>\n\u003cdiv class=\"gql-nested-content\">\n\u003cdiv class=\"gql-nested-type-heading\">GranteeType fields\u003c/div>\n\u003cul class=\"gql-field-list\">\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">externalId\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">name\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003c/ul>\n\u003c/div>\n\u003c/details>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">id\u003c/span>\n\u003cspan class=\"gql-type-tag\">ID!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003cdiv class=\"gql-field-desc\">The Globally Unique ID of this object\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">live\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">merchantOrderId\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">merchantPublicId\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">offerPublicId\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli>\n\u003cdetails class=\"gql-nested-type\">\n\u003csummary>\n\u003cspan class=\"gql-field-name\">payment\u003c/span>\n\u003ca class=\"gql-type-tag\" href=\"graphql-type-PaymentType\">PaymentType\u003c/a>\n\u003cspan class=\"gql-show-fields\">Show fields\u003c/span>\n\u003c/summary>\n\u003cdiv class=\"gql-nested-content\">\n\u003cdiv class=\"gql-nested-type-heading\">PaymentType fields\u003c/div>\n\u003cul class=\"gql-field-list\">\n\u003cli>\n\u003cdetails class=\"gql-nested-type\">\n\u003csummary>\n\u003cspan class=\"gql-field-name\">billingAddress\u003c/span>\n\u003ca class=\"gql-type-tag\" href=\"graphql-type-AddressType\">AddressType\u003c/a>\n\u003cspan class=\"gql-show-fields\">Show fields\u003c/span>\n\u003c/summary>\n\u003cdiv class=\"gql-nested-content\">\n\u003cdiv class=\"gql-nested-type-heading\">AddressType fields\u003c/div>\n\u003cul class=\"gql-field-list\">\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">address\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">address2\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">city\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">companyName\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">countryCode\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">created\u003c/span>\n\u003cspan class=\"gql-type-tag\">DateTime!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">fax\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">firstName\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">label\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">lastName\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">live\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">phone\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">priceCode\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">publicId\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">stateProvinceCode\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">tokenId\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">zipPostalCode\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003c/ul>\n\u003c/div>\n\u003c/details>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">ccExpDate\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">ccHolder\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">ccNumberEnding\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">ccType\u003c/span>\n\u003cspan class=\"gql-type-tag\">Int\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">created\u003c/span>\n\u003cspan class=\"gql-type-tag\">DateTime!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">cycle\u003c/span>\n\u003cspan class=\"gql-type-tag\">Int\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">cycleStatus\u003c/span>\n\u003cspan class=\"gql-type-tag\">Int\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">label\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">lastUpdated\u003c/span>\n\u003cspan class=\"gql-type-tag\">DateTime!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">live\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">paymentMethod\u003c/span>\n\u003cspan class=\"gql-type-tag\">Int\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">publicId\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">tokenId\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003c/ul>\n\u003c/div>\n\u003c/details>\n\u003c/li>\n\u003cli>\n\u003cdetails class=\"gql-nested-type\">\n\u003csummary>\n\u003cspan class=\"gql-field-name\">prepaidSubscriptionContext\u003c/span>\n\u003ca class=\"gql-type-tag\" href=\"graphql-type-PrepaidSubscriptionContextType\">PrepaidSubscriptionContextType\u003c/a>\n\u003cspan class=\"gql-show-fields\">Show fields\u003c/span>\n\u003c/summary>\n\u003cdiv class=\"gql-nested-content\">\n\u003cdiv class=\"gql-nested-type-heading\">PrepaidSubscriptionContextType fields\u003c/div>\n\u003cul class=\"gql-field-list\">\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">lastRenewalRevenue\u003c/span>\n\u003cspan class=\"gql-type-tag\">Decimal!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">prepaidOrdersPerBilling\u003c/span>\n\u003cspan class=\"gql-type-tag\">Int!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">prepaidOrdersRemaining\u003c/span>\n\u003cspan class=\"gql-type-tag\">Int!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">prepaidOriginMerchantOrderId\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">renewalBehavior\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003c/ul>\n\u003c/div>\n\u003c/details>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">price\u003c/span>\n\u003cspan class=\"gql-type-tag\">Decimal\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli>\n\u003cdetails class=\"gql-nested-type\">\n\u003csummary>\n\u003cspan class=\"gql-field-name\">product\u003c/span>\n\u003ca class=\"gql-type-tag\" href=\"graphql-type-ProductType\">ProductType\u003c/a>\n\u003cspan class=\"gql-show-fields\">Show fields\u003c/span>\n\u003c/summary>\n\u003cdiv class=\"gql-nested-content\">\n\u003cdiv class=\"gql-nested-type-heading\">ProductType fields\u003c/div>\n\u003cul class=\"gql-field-list\">\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">autoshipByDefault\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">autoshipEnabled\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">created\u003c/span>\n\u003cspan class=\"gql-type-tag\">DateTime\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">detailUrl\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">discontinued\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">every\u003c/span>\n\u003cspan class=\"gql-type-tag\">Int\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">everyPeriod\u003c/span>\n\u003cspan class=\"gql-type-tag\">Int\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">externalProductId\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">extraData\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli>\n\u003cdetails class=\"gql-nested-type\">\n\u003csummary>\n\u003cspan class=\"gql-field-name\">groups\u003c/span>\n\u003ca class=\"gql-type-tag\" href=\"graphql-type-ProductGroupType\">[ProductGroupType!]!\u003c/a>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003cspan class=\"gql-show-fields\">Show fields\u003c/span>\n\u003c/summary>\n\u003cdiv class=\"gql-nested-content\">\n\u003cdiv class=\"gql-nested-type-heading\">ProductGroupType fields\u003c/div>\n\u003cul class=\"gql-field-list\">\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">groupType\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">name\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003c/ul>\n\u003c/div>\n\u003c/details>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">imageUrl\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">lastUpdate\u003c/span>\n\u003cspan class=\"gql-type-tag\">DateTime\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">live\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">name\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">prepaidEligible\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">price\u003c/span>\n\u003cspan class=\"gql-type-tag\">Decimal!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">productType\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">sku\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003c/ul>\n\u003c/div>\n\u003c/details>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">publicId\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">quantity\u003c/span>\n\u003cspan class=\"gql-type-tag\">Int!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli>\n\u003cdetails class=\"gql-nested-type\">\n\u003csummary>\n\u003cspan class=\"gql-field-name\">queuedActions\u003c/span>\n\u003ca class=\"gql-type-tag\" href=\"graphql-type-QueuedActionType\">[QueuedActionType!]\u003c/a>\n\u003cspan class=\"gql-show-fields\">Show fields\u003c/span>\n\u003c/summary>\n\u003cdiv class=\"gql-nested-content\">\n\u003cdiv class=\"gql-nested-type-heading\">QueuedActionType fields\u003c/div>\n\u003cul class=\"gql-field-list\">\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">date\u003c/span>\n\u003cspan class=\"gql-type-tag\">DateTime\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">index\u003c/span>\n\u003cspan class=\"gql-type-tag\">Int!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">ordinal\u003c/span>\n\u003cspan class=\"gql-type-tag\">Int!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">publicId\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">skip\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003c/ul>\n\u003c/div>\n\u003c/details>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">reminderDays\u003c/span>\n\u003cspan class=\"gql-type-tag\">Int\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">sessionId\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli>\n\u003cdetails class=\"gql-nested-type\">\n\u003csummary>\n\u003cspan class=\"gql-field-name\">shippingAddress\u003c/span>\n\u003ca class=\"gql-type-tag\" href=\"graphql-type-AddressType\">AddressType\u003c/a>\n\u003cspan class=\"gql-show-fields\">Show fields\u003c/span>\n\u003c/summary>\n\u003cdiv class=\"gql-nested-content\">\n\u003cdiv class=\"gql-nested-type-heading\">AddressType fields\u003c/div>\n\u003cul class=\"gql-field-list\">\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">address\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">address2\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">city\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">companyName\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">countryCode\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">created\u003c/span>\n\u003cspan class=\"gql-type-tag\">DateTime!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">fax\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">firstName\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">label\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">lastName\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">live\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">phone\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">priceCode\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">publicId\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">stateProvinceCode\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">tokenId\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">zipPostalCode\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003c/ul>\n\u003c/div>\n\u003c/details>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">startDate\u003c/span>\n\u003cspan class=\"gql-type-tag\">Date!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">subscriptionType\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">updated\u003c/span>\n\u003cspan class=\"gql-type-tag\">DateTime\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003c/ul>\n\u003c/div>\n\u003c/details>\n\u003c/li>\n\u003cli>\n\u003cdetails class=\"gql-nested-type\">\n\u003csummary>\n\u003cspan class=\"gql-field-name\">subscriptionComponent\u003c/span>\n\u003ca class=\"gql-type-tag\" href=\"graphql-type-ComponentType\">ComponentType\u003c/a>\n\u003cspan class=\"gql-show-fields\">Show fields\u003c/span>\n\u003c/summary>\n\u003cdiv class=\"gql-nested-content\">\n\u003cdiv class=\"gql-nested-type-heading\">ComponentType fields\u003c/div>\n\u003cul class=\"gql-field-list\">\n\u003cli>\n\u003cdetails class=\"gql-nested-type\">\n\u003csummary>\n\u003cspan class=\"gql-field-name\">product\u003c/span>\n\u003ca class=\"gql-type-tag\" href=\"graphql-type-ProductType\">ProductType\u003c/a>\n\u003cspan class=\"gql-show-fields\">Show fields\u003c/span>\n\u003c/summary>\n\u003cdiv class=\"gql-nested-content\">\n\u003cdiv class=\"gql-nested-type-heading\">ProductType fields\u003c/div>\n\u003cul class=\"gql-field-list\">\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">autoshipByDefault\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">autoshipEnabled\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">created\u003c/span>\n\u003cspan class=\"gql-type-tag\">DateTime\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">detailUrl\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">discontinued\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">every\u003c/span>\n\u003cspan class=\"gql-type-tag\">Int\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">everyPeriod\u003c/span>\n\u003cspan class=\"gql-type-tag\">Int\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">externalProductId\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">extraData\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli>\n\u003cdetails class=\"gql-nested-type\">\n\u003csummary>\n\u003cspan class=\"gql-field-name\">groups\u003c/span>\n\u003ca class=\"gql-type-tag\" href=\"graphql-type-ProductGroupType\">[ProductGroupType!]!\u003c/a>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003cspan class=\"gql-show-fields\">Show fields\u003c/span>\n\u003c/summary>\n\u003cdiv class=\"gql-nested-content\">\n\u003cdiv class=\"gql-nested-type-heading\">ProductGroupType fields\u003c/div>\n\u003cul class=\"gql-field-list\">\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">groupType\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">name\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003c/ul>\n\u003c/div>\n\u003c/details>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">imageUrl\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">lastUpdate\u003c/span>\n\u003cspan class=\"gql-type-tag\">DateTime\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">live\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">name\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">prepaidEligible\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">price\u003c/span>\n\u003cspan class=\"gql-type-tag\">Decimal!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">productType\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">sku\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003c/ul>\n\u003c/div>\n\u003c/details>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">publicId\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">quantity\u003c/span>\n\u003cspan class=\"gql-type-tag\">Int\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003c/ul>\n\u003c/div>\n\u003c/details>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">totalPrice\u003c/span>\n\u003cspan class=\"gql-type-tag\">Decimal!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003c/ul>\n\u003c/div>\n\u003c/details>\n\u003c/li>\n\u003c/ul>\n\u003c/div>\n\u003c/details>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">locked\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">merchantPublicId\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli>\n\u003cdetails class=\"gql-nested-type\">\n\u003csummary>\n\u003cspan class=\"gql-field-name\">oneTimeIncentives\u003c/span>\n\u003ca class=\"gql-type-tag\" href=\"graphql-type-OneTimeIncentiveType\">[OneTimeIncentiveType!]!\u003c/a>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003cspan class=\"gql-show-fields\">Show fields\u003c/span>\n\u003c/summary>\n\u003cdiv class=\"gql-nested-content\">\n\u003cdiv class=\"gql-nested-type-heading\">OneTimeIncentiveType fields\u003c/div>\n\u003cul class=\"gql-field-list\">\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">appliedAt\u003c/span>\n\u003cspan class=\"gql-type-tag\">DateTime\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">created\u003c/span>\n\u003cspan class=\"gql-type-tag\">DateTime!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">description\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">expires\u003c/span>\n\u003cspan class=\"gql-type-tag\">DateTime\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">externalCode\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli>\n\u003cdetails class=\"gql-nested-type\">\n\u003csummary>\n\u003cspan class=\"gql-field-name\">incentive\u003c/span>\n\u003ca class=\"gql-type-tag\" href=\"graphql-type-IncentiveType\">IncentiveType\u003c/a>\n\u003cspan class=\"gql-show-fields\">Show fields\u003c/span>\n\u003c/summary>\n\u003cdiv class=\"gql-nested-content\">\n\u003cdiv class=\"gql-nested-type-heading\">IncentiveType fields \u003cspan class=\"gql-badge gql-badge-interface\">Interface\u003c/span>\u003c/div>\n\u003cul class=\"gql-field-list\">\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">name\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">publicId\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003c/ul>\n\u003cdiv class=\"gql-implementations\">\n\u003cdiv class=\"gql-nested-type-heading\">Implemented by\u003c/div>\n\u003cul class=\"gql-impl-list\">\n\u003cli class=\"gql-impl-item\">\n\u003ca class=\"gql-impl-link\" href=\"graphql-type-BaseIncentiveType\">BaseIncentive\u003c/a>\n\u003c/li>\n\u003cli class=\"gql-impl-item\">\n\u003ca class=\"gql-impl-link\" href=\"graphql-type-DiscountIncentiveType\">DiscountIncentive\u003c/a>\n\u003cdiv class=\"gql-impl-fields\">discountType: String!, field: String!, limitPolicy: String, limitValue: Decimal, target: String!, thresholdField: String, thresholdValue: Decimal, value: Decimal!\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-impl-item\">\n\u003ca class=\"gql-impl-link\" href=\"graphql-type-GiftIncentiveType\">GiftIncentive\u003c/a>\n\u003cdiv class=\"gql-impl-fields\">product: ProductType, target: String!\u003c/div>\n\u003c/li>\n\u003c/ul>\n\u003c/div>\n\u003c/div>\n\u003c/details>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">lastUpdated\u003c/span>\n\u003cspan class=\"gql-type-tag\">DateTime!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">onetimeCouponType\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">publicId\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">stackingType\u003c/span>\n\u003cspan class=\"gql-type-tag\">Int!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003c/ul>\n\u003c/div>\n\u003c/details>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">oosFreeShipping\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">orderMerchantId\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli>\n\u003cdetails class=\"gql-nested-type\">\n\u003csummary>\n\u003cspan class=\"gql-field-name\">payment\u003c/span>\n\u003ca class=\"gql-type-tag\" href=\"graphql-type-PaymentType\">PaymentType\u003c/a>\n\u003cspan class=\"gql-show-fields\">Show fields\u003c/span>\n\u003c/summary>\n\u003cdiv class=\"gql-nested-content\">\n\u003cdiv class=\"gql-nested-type-heading\">PaymentType fields\u003c/div>\n\u003cul class=\"gql-field-list\">\n\u003cli>\n\u003cdetails class=\"gql-nested-type\">\n\u003csummary>\n\u003cspan class=\"gql-field-name\">billingAddress\u003c/span>\n\u003ca class=\"gql-type-tag\" href=\"graphql-type-AddressType\">AddressType\u003c/a>\n\u003cspan class=\"gql-show-fields\">Show fields\u003c/span>\n\u003c/summary>\n\u003cdiv class=\"gql-nested-content\">\n\u003cdiv class=\"gql-nested-type-heading\">AddressType fields\u003c/div>\n\u003cul class=\"gql-field-list\">\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">address\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">address2\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">city\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">companyName\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">countryCode\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">created\u003c/span>\n\u003cspan class=\"gql-type-tag\">DateTime!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">fax\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">firstName\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">label\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">lastName\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">live\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">phone\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">priceCode\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">publicId\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">stateProvinceCode\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">tokenId\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">zipPostalCode\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003c/ul>\n\u003c/div>\n\u003c/details>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">ccExpDate\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">ccHolder\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">ccNumberEnding\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">ccType\u003c/span>\n\u003cspan class=\"gql-type-tag\">Int\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">created\u003c/span>\n\u003cspan class=\"gql-type-tag\">DateTime!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">cycle\u003c/span>\n\u003cspan class=\"gql-type-tag\">Int\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">cycleStatus\u003c/span>\n\u003cspan class=\"gql-type-tag\">Int\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">label\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">lastUpdated\u003c/span>\n\u003cspan class=\"gql-type-tag\">DateTime!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">live\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">paymentMethod\u003c/span>\n\u003cspan class=\"gql-type-tag\">Int\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">publicId\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">tokenId\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003c/ul>\n\u003c/div>\n\u003c/details>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">place\u003c/span>\n\u003cspan class=\"gql-type-tag\">DateTime\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">publicId\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">rejectedMessage\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli>\n\u003cdetails class=\"gql-nested-type\">\n\u003csummary>\n\u003cspan class=\"gql-field-name\">shippingAddress\u003c/span>\n\u003ca class=\"gql-type-tag\" href=\"graphql-type-AddressType\">AddressType\u003c/a>\n\u003cspan class=\"gql-show-fields\">Show fields\u003c/span>\n\u003c/summary>\n\u003cdiv class=\"gql-nested-content\">\n\u003cdiv class=\"gql-nested-type-heading\">AddressType fields\u003c/div>\n\u003cul class=\"gql-field-list\">\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">address\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">address2\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">city\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">companyName\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">countryCode\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">created\u003c/span>\n\u003cspan class=\"gql-type-tag\">DateTime!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">fax\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">firstName\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">label\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">lastName\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">live\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">phone\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">priceCode\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">publicId\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">stateProvinceCode\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">tokenId\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">zipPostalCode\u003c/span>\n\u003cspan class=\"gql-type-tag\">String!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003c/ul>\n\u003c/div>\n\u003c/details>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">shippingTotal\u003c/span>\n\u003cspan class=\"gql-type-tag\">Decimal!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">status\u003c/span>\n\u003cspan class=\"gql-type-tag\">Int!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">subTotal\u003c/span>\n\u003cspan class=\"gql-type-tag\">Decimal!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">taxTotal\u003c/span>\n\u003cspan class=\"gql-type-tag\">Decimal!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">total\u003c/span>\n\u003cspan class=\"gql-type-tag\">Decimal!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">tries\u003c/span>\n\u003cspan class=\"gql-type-tag\">Int!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">updated\u003c/span>\n\u003cspan class=\"gql-type-tag\">DateTime\u003c/span>\n\u003c/div>\n\u003c/li>\n\u003c/ul>\n\u003c/div>\n\u003c/details>\n\u003c/li>\n\u003c/ul>\n\u003c/div>\n\u003c/details>\n\u003c/li>\n\u003cli>\n\u003cdetails class=\"gql-nested-type\">\n\u003csummary>\n\u003cspan class=\"gql-field-name\">pageInfo\u003c/span>\n\u003cspan class=\"gql-type-tag\">PageInfo!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003cspan class=\"gql-show-fields\">Show fields\u003c/span>\n\u003c/summary>\n\u003cdiv class=\"gql-nested-content\">\n\u003cdiv class=\"gql-nested-type-heading\">PageInfo fields\u003c/div>\n\u003cul class=\"gql-field-list\">\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">endCursor\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003cdiv class=\"gql-field-desc\">When paginating forwards, the cursor to continue.\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">hasNextPage\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003cdiv class=\"gql-field-desc\">When paginating forwards, are there more items?\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">hasPreviousPage\u003c/span>\n\u003cspan class=\"gql-type-tag\">Boolean!\u003c/span>\n\u003cspan class=\"gql-badge gql-badge-non-null\">Non-null\u003c/span>\n\u003c/div>\n\u003cdiv class=\"gql-field-desc\">When paginating backwards, are there more items?\u003c/div>\n\u003c/li>\n\u003cli class=\"gql-field-item\">\n\u003cdiv class=\"gql-field-row\">\n\u003cspan class=\"gql-field-name\">startCursor\u003c/span>\n\u003cspan class=\"gql-type-tag\">String\u003c/span>\n\u003c/div>\n\u003cdiv class=\"gql-field-desc\">When paginating backwards, the cursor to continue.\u003c/div>\n\u003c/li>\n\u003c/ul>\n\u003c/div>\n\u003c/details>\n\u003c/li>\n\u003c/ul>\n    \u003c/div>\n\n    \u003cdiv class=\"gql-sidebar\">\n      \u003cdiv class=\"gql-sidebar-inner\">\n\u003cdiv class=\"gql-examples\">\n\u003cinput type=\"radio\" class=\"gql-ex-select\" name=\"exsel-orders\" id=\"exsel-orders-0\" checked>\n\u003clabel class=\"gql-ex-select-label\" for=\"exsel-orders-0\">List recent orders for a customer\u003c/label>\n\u003cinput type=\"radio\" class=\"gql-ex-select\" name=\"exsel-orders\" id=\"exsel-orders-1\">\n\u003clabel class=\"gql-ex-select-label\" for=\"exsel-orders-1\">List orders with pagination\u003c/label>\n\u003cinput type=\"radio\" class=\"gql-ex-select\" name=\"exsel-orders\" id=\"exsel-orders-2\">\n\u003clabel class=\"gql-ex-select-label\" for=\"exsel-orders-2\">Get subscription details by customer\u003c/label>\n\u003cinput type=\"radio\" class=\"gql-ex-select\" name=\"exsel-orders\" id=\"exsel-orders-3\">\n\u003clabel class=\"gql-ex-select-label\" for=\"exsel-orders-3\">Get subscription details by subscription\u003c/label>\n\u003cdiv class=\"gql-example\">\n\u003cp class=\"gql-example-desc\">Retrieve a customer&#x27;s order history with basic info\u003c/p>\n\u003cdiv class=\"gql-example-tabs\">\n\u003cinput type=\"radio\" name=\"ex-orders-0\" id=\"ex-orders-0-0\" checked>\n\u003clabel for=\"ex-orders-0-0\">GraphQL\u003c/label>\n\u003cinput type=\"radio\" name=\"ex-orders-0\" id=\"ex-orders-0-1\">\n\u003clabel for=\"ex-orders-0-1\">cURL\u003c/label>\n\u003cinput type=\"radio\" name=\"ex-orders-0\" id=\"ex-orders-0-2\">\n\u003clabel for=\"ex-orders-0-2\">Node.js\u003c/label>\n\u003cinput type=\"radio\" name=\"ex-orders-0\" id=\"ex-orders-0-3\">\n\u003clabel for=\"ex-orders-0-3\">Python\u003c/label>\n\u003cdiv class=\"gql-example-panel\">\u003cpre>\u003ccode>\u003cspan class=\"kw\">query\u003c/span> {\n  orders(customer: \u003cspan class=\"st\">&quot;cust123&quot;\u003c/span>, first: \u003cspan class=\"nu\">10\u003c/span>) {\n    edges {\n      node {\n        publicId\n        status\n        subTotal\n        total\n        place\n        created\n        items {\n          nodes {\n            quantity\n            product {\n              name\n              externalProductId\n            }\n          }\n        }\n      }\n    }\n  }\n}\u003c/code>\u003c/pre>\u003c/div>\n\u003cdiv class=\"gql-example-panel\">\u003cpre>\u003ccode>\u003cspan class=\"kw\">curl\u003c/span> -X POST https://restapi.ordergroove.com/graphql/\u003cspan class=\"nu\">2026\u003c/span>-\u003cspan class=\"nu\">01\u003c/span>/ \\\n  -H \u003cspan class=\"st\">&quot;X-API-KEY: &lt;your-api-key&gt;&quot;\u003c/span> \\\n  -H \u003cspan class=\"st\">&quot;Content-Type: application/json&quot;\u003c/span> \\\n  -d \u003cspan class=\"st\">&#x27;{&quot;query&quot;: &quot;query { orders(customer: \\&quot;cust123\\&quot;, first: 10) { edges { node { publicId status subTotal total place created items { nodes { quantity product { name externalProductId } } } } } } }&quot;}&#x27;\u003c/span>\u003c/code>\u003c/pre>\u003c/div>\n\u003cdiv class=\"gql-example-panel\">\u003cpre>\u003ccode>\u003cspan class=\"kw\">const\u003c/span> query = \u003cspan class=\"st\">`\nquery {\n  orders(customer: &quot;cust123&quot;, first: 10) {\n    edges {\n      node {\n        publicId\n        status\n        subTotal\n        total\n        place\n        created\n        items {\n          nodes {\n            quantity\n            product {\n              name\n              externalProductId\n            }\n          }\n        }\n      }\n    }\n  }\n}\n`\u003c/span>;\n\n\u003cspan class=\"kw\">const\u003c/span> response = \u003cspan class=\"kw\">await\u003c/span> fetch(\n  \u003cspan class=\"st\">&quot;https://restapi.ordergroove.com/graphql/2026-01/&quot;\u003c/span>,\n  {\n    method: \u003cspan class=\"st\">&quot;POST&quot;\u003c/span>,\n    headers: {\n      \u003cspan class=\"st\">&quot;X-API-KEY: &lt;your-api-key&gt;&quot;\u003c/span>,\n      \u003cspan class=\"st\">&quot;Content-Type&quot;\u003c/span>: \u003cspan class=\"st\">&quot;application/json&quot;\u003c/span>,\n    },\n    body: JSON.stringify({ query }),\n  }\n);\n\n\u003cspan class=\"kw\">const\u003c/span> data = \u003cspan class=\"kw\">await\u003c/span> response.json();\u003c/code>\u003c/pre>\u003c/div>\n\u003cdiv class=\"gql-example-panel\">\u003cpre>\u003ccode>\u003cspan class=\"kw\">import\u003c/span> requests\n\nquery = \u003cspan class=\"st\">&quot;&quot;&quot;\nquery {\n  orders(customer: &quot;cust123&quot;, first: 10) {\n    edges {\n      node {\n        publicId\n        status\n        subTotal\n        total\n        place\n        created\n        items {\n          nodes {\n            quantity\n            product {\n              name\n              externalProductId\n            }\n          }\n        }\n      }\n    }\n  }\n}\n&quot;&quot;&quot;\u003c/span>\n\nresponse = requests.post(\n    \u003cspan class=\"st\">&quot;https://restapi.ordergroove.com/graphql/2026-01/&quot;\u003c/span>,\n    headers={\n        \u003cspan class=\"st\">&quot;X-API-KEY: &lt;your-api-key&gt;&quot;\u003c/span>,\n        \u003cspan class=\"st\">&quot;Content-Type&quot;\u003c/span>: \u003cspan class=\"st\">&quot;application/json&quot;\u003c/span>,\n    },\n    json={\u003cspan class=\"st\">&quot;query&quot;\u003c/span>: query},\n)\n\ndata = response.json()\u003c/code>\u003c/pre>\u003c/div>\n\u003c/div>\n\u003c/div>\n\u003cdiv class=\"gql-example\">\n\u003cp class=\"gql-example-desc\">Page through a customer&#x27;s orders using cursor-based pagination\u003c/p>\n\u003cdiv class=\"gql-example-tabs\">\n\u003cinput type=\"radio\" name=\"ex-orders-1\" id=\"ex-orders-1-0\" checked>\n\u003clabel for=\"ex-orders-1-0\">GraphQL\u003c/label>\n\u003cinput type=\"radio\" name=\"ex-orders-1\" id=\"ex-orders-1-1\">\n\u003clabel for=\"ex-orders-1-1\">cURL\u003c/label>\n\u003cinput type=\"radio\" name=\"ex-orders-1\" id=\"ex-orders-1-2\">\n\u003clabel for=\"ex-orders-1-2\">Node.js\u003c/label>\n\u003cinput type=\"radio\" name=\"ex-orders-1\" id=\"ex-orders-1-3\">\n\u003clabel for=\"ex-orders-1-3\">Python\u003c/label>\n\u003cdiv class=\"gql-example-panel\">\u003cpre>\u003ccode>\u003cspan class=\"kw\">query\u003c/span> {\n  orders(customer: \u003cspan class=\"st\">&quot;cust123&quot;\u003c/span>, first: \u003cspan class=\"nu\">10\u003c/span>, after: \u003cspan class=\"st\">&quot;cursor123&quot;\u003c/span>) {\n    edges {\n      cursor\n      node {\n        publicId\n        status\n        subTotal\n        total\n        place\n        created\n      }\n    }\n    pageInfo {\n      hasNextPage\n      hasPreviousPage\n      startCursor\n      endCursor\n    }\n  }\n}\u003c/code>\u003c/pre>\u003c/div>\n\u003cdiv class=\"gql-example-panel\">\u003cpre>\u003ccode>\u003cspan class=\"kw\">curl\u003c/span> -X POST https://restapi.ordergroove.com/graphql/\u003cspan class=\"nu\">2026\u003c/span>-\u003cspan class=\"nu\">01\u003c/span>/ \\\n  -H \u003cspan class=\"st\">&quot;X-API-KEY: &lt;your-api-key&gt;&quot;\u003c/span> \\\n  -H \u003cspan class=\"st\">&quot;Content-Type: application/json&quot;\u003c/span> \\\n  -d \u003cspan class=\"st\">&#x27;{&quot;query&quot;: &quot;query { orders(customer: \\&quot;cust123\\&quot;, first: 10, after: \\&quot;cursor123\\&quot;) { edges { cursor node { publicId status subTotal total place created } } pageInfo { hasNextPage hasPreviousPage startCursor endCursor } } }&quot;}&#x27;\u003c/span>\u003c/code>\u003c/pre>\u003c/div>\n\u003cdiv class=\"gql-example-panel\">\u003cpre>\u003ccode>\u003cspan class=\"kw\">const\u003c/span> query = \u003cspan class=\"st\">`\nquery {\n  orders(customer: &quot;cust123&quot;, first: 10, after: &quot;cursor123&quot;) {\n    edges {\n      cursor\n      node {\n        publicId\n        status\n        subTotal\n        total\n        place\n        created\n      }\n    }\n    pageInfo {\n      hasNextPage\n      hasPreviousPage\n      startCursor\n      endCursor\n    }\n  }\n}\n`\u003c/span>;\n\n\u003cspan class=\"kw\">const\u003c/span> response = \u003cspan class=\"kw\">await\u003c/span> fetch(\n  \u003cspan class=\"st\">&quot;https://restapi.ordergroove.com/graphql/2026-01/&quot;\u003c/span>,\n  {\n    method: \u003cspan class=\"st\">&quot;POST&quot;\u003c/span>,\n    headers: {\n      \u003cspan class=\"st\">&quot;X-API-KEY: &lt;your-api-key&gt;&quot;\u003c/span>,\n      \u003cspan class=\"st\">&quot;Content-Type&quot;\u003c/span>: \u003cspan class=\"st\">&quot;application/json&quot;\u003c/span>,\n    },\n    body: JSON.stringify({ query }),\n  }\n);\n\n\u003cspan class=\"kw\">const\u003c/span> data = \u003cspan class=\"kw\">await\u003c/span> response.json();\u003c/code>\u003c/pre>\u003c/div>\n\u003cdiv class=\"gql-example-panel\">\u003cpre>\u003ccode>\u003cspan class=\"kw\">import\u003c/span> requests\n\nquery = \u003cspan class=\"st\">&quot;&quot;&quot;\nquery {\n  orders(customer: &quot;cust123&quot;, first: 10, after: &quot;cursor123&quot;) {\n    edges {\n      cursor\n      node {\n        publicId\n        status\n        subTotal\n        total\n        place\n        created\n      }\n    }\n    pageInfo {\n      hasNextPage\n      hasPreviousPage\n      startCursor\n      endCursor\n    }\n  }\n}\n&quot;&quot;&quot;\u003c/span>\n\nresponse = requests.post(\n    \u003cspan class=\"st\">&quot;https://restapi.ordergroove.com/graphql/2026-01/&quot;\u003c/span>,\n    headers={\n        \u003cspan class=\"st\">&quot;X-API-KEY: &lt;your-api-key&gt;&quot;\u003c/span>,\n        \u003cspan class=\"st\">&quot;Content-Type&quot;\u003c/span>: \u003cspan class=\"st\">&quot;application/json&quot;\u003c/span>,\n    },\n    json={\u003cspan class=\"st\">&quot;query&quot;\u003c/span>: query},\n)\n\ndata = response.json()\u003c/code>\u003c/pre>\u003c/div>\n\u003c/div>\n\u003c/div>\n\u003cdiv class=\"gql-example\">\n\u003cp class=\"gql-example-desc\">Detailed orders by customer\u003c/p>\n\u003cdiv class=\"gql-example-tabs\">\n\u003cinput type=\"radio\" name=\"ex-orders-2\" id=\"ex-orders-2-0\" checked>\n\u003clabel for=\"ex-orders-2-0\">GraphQL\u003c/label>\n\u003cinput type=\"radio\" name=\"ex-orders-2\" id=\"ex-orders-2-1\">\n\u003clabel for=\"ex-orders-2-1\">cURL\u003c/label>\n\u003cinput type=\"radio\" name=\"ex-orders-2\" id=\"ex-orders-2-2\">\n\u003clabel for=\"ex-orders-2-2\">Node.js\u003c/label>\n\u003cinput type=\"radio\" name=\"ex-orders-2\" id=\"ex-orders-2-3\">\n\u003clabel for=\"ex-orders-2-3\">Python\u003c/label>\n\u003cdiv class=\"gql-example-panel\">\u003cpre>\u003ccode>\u003cspan class=\"kw\">query\u003c/span> {\n  orders(customer: \u003cspan class=\"st\">&quot;cust123&quot;\u003c/span>, first: \u003cspan class=\"nu\">25\u003c/span>) {\n    edges {\n      node {\n        publicId\n        status\n        subTotal\n        total\n        place\n        items {\n          nodes {\n            publicId\n            quantity\n            price\n            totalPrice\n            product {\n              name\n              externalProductId\n              sku\n            }\n            \u003cspan class=\"kw\">subscription\u003c/span> {\n              publicId\n              every\n              everyPeriod\n            }\n          }\n        }\n      }\n    }\n  }\n}\u003c/code>\u003c/pre>\u003c/div>\n\u003cdiv class=\"gql-example-panel\">\u003cpre>\u003ccode>\u003cspan class=\"kw\">curl\u003c/span> -X POST https://restapi.ordergroove.com/graphql/\u003cspan class=\"nu\">2026\u003c/span>-\u003cspan class=\"nu\">01\u003c/span>/ \\\n  -H \u003cspan class=\"st\">&quot;X-API-KEY: &lt;your-api-key&gt;&quot;\u003c/span> \\\n  -H \u003cspan class=\"st\">&quot;Content-Type: application/json&quot;\u003c/span> \\\n  -d \u003cspan class=\"st\">&#x27;{&quot;query&quot;: &quot;query { orders(customer: \\&quot;cust123\\&quot;, first: 25) { edges { node { publicId status subTotal total place items { nodes { publicId quantity price totalPrice product { name externalProductId sku } subscription { publicId every everyPeriod } } } } } } }&quot;}&#x27;\u003c/span>\u003c/code>\u003c/pre>\u003c/div>\n\u003cdiv class=\"gql-example-panel\">\u003cpre>\u003ccode>\u003cspan class=\"kw\">const\u003c/span> query = \u003cspan class=\"st\">`\nquery {\n  orders(customer: &quot;cust123&quot;, first: 25) {\n    edges {\n      node {\n        publicId\n        status\n        subTotal\n        total\n        place\n        items {\n          nodes {\n            publicId\n            quantity\n            price\n            totalPrice\n            product {\n              name\n              externalProductId\n              sku\n            }\n            subscription {\n              publicId\n              every\n              everyPeriod\n            }\n          }\n        }\n      }\n    }\n  }\n}\n`\u003c/span>;\n\n\u003cspan class=\"kw\">const\u003c/span> response = \u003cspan class=\"kw\">await\u003c/span> fetch(\n  \u003cspan class=\"st\">&quot;https://restapi.ordergroove.com/graphql/2026-01/&quot;\u003c/span>,\n  {\n    method: \u003cspan class=\"st\">&quot;POST&quot;\u003c/span>,\n    headers: {\n      \u003cspan class=\"st\">&quot;X-API-KEY: &lt;your-api-key&gt;&quot;\u003c/span>,\n      \u003cspan class=\"st\">&quot;Content-Type&quot;\u003c/span>: \u003cspan class=\"st\">&quot;application/json&quot;\u003c/span>,\n    },\n    body: JSON.stringify({ query }),\n  }\n);\n\n\u003cspan class=\"kw\">const\u003c/span> data = \u003cspan class=\"kw\">await\u003c/span> response.json();\u003c/code>\u003c/pre>\u003c/div>\n\u003cdiv class=\"gql-example-panel\">\u003cpre>\u003ccode>\u003cspan class=\"kw\">import\u003c/span> requests\n\nquery = \u003cspan class=\"st\">&quot;&quot;&quot;\nquery {\n  orders(customer: &quot;cust123&quot;, first: 25) {\n    edges {\n      node {\n        publicId\n        status\n        subTotal\n        total\n        place\n        items {\n          nodes {\n            publicId\n            quantity\n            price\n            totalPrice\n            product {\n              name\n              externalProductId\n              sku\n            }\n            subscription {\n              publicId\n              every\n              everyPeriod\n            }\n          }\n        }\n      }\n    }\n  }\n}\n&quot;&quot;&quot;\u003c/span>\n\nresponse = requests.post(\n    \u003cspan class=\"st\">&quot;https://restapi.ordergroove.com/graphql/2026-01/&quot;\u003c/span>,\n    headers={\n        \u003cspan class=\"st\">&quot;X-API-KEY: &lt;your-api-key&gt;&quot;\u003c/span>,\n        \u003cspan class=\"st\">&quot;Content-Type&quot;\u003c/span>: \u003cspan class=\"st\">&quot;application/json&quot;\u003c/span>,\n    },\n    json={\u003cspan class=\"st\">&quot;query&quot;\u003c/span>: query},\n)\n\ndata = response.json()\u003c/code>\u003c/pre>\u003c/div>\n\u003c/div>\n\u003c/div>\n\u003cdiv class=\"gql-example\">\n\u003cp class=\"gql-example-desc\">Retrieve orders for a specific subscription with line item details\u003c/p>\n\u003cdiv class=\"gql-example-tabs\">\n\u003cinput type=\"radio\" name=\"ex-orders-3\" id=\"ex-orders-3-0\" checked>\n\u003clabel for=\"ex-orders-3-0\">GraphQL\u003c/label>\n\u003cinput type=\"radio\" name=\"ex-orders-3\" id=\"ex-orders-3-1\">\n\u003clabel for=\"ex-orders-3-1\">cURL\u003c/label>\n\u003cinput type=\"radio\" name=\"ex-orders-3\" id=\"ex-orders-3-2\">\n\u003clabel for=\"ex-orders-3-2\">Node.js\u003c/label>\n\u003cinput type=\"radio\" name=\"ex-orders-3\" id=\"ex-orders-3-3\">\n\u003clabel for=\"ex-orders-3-3\">Python\u003c/label>\n\u003cdiv class=\"gql-example-panel\">\u003cpre>\u003ccode>\u003cspan class=\"kw\">query\u003c/span> {\n  orders(\u003cspan class=\"kw\">subscription\u003c/span>: \u003cspan class=\"st\">&quot;sub123&quot;\u003c/span>, first: \u003cspan class=\"nu\">25\u003c/span>) {\n    edges {\n      node {\n        publicId\n        status\n        subTotal\n        total\n        place\n        created\n        items {\n          nodes {\n            publicId\n            quantity\n            price\n            totalPrice\n            product {\n              name\n              externalProductId\n              sku\n            }\n            \u003cspan class=\"kw\">subscription\u003c/span> {\n              publicId\n              every\n              everyPeriod\n            }\n          }\n        }\n      }\n    }\n  }\n}\u003c/code>\u003c/pre>\u003c/div>\n\u003cdiv class=\"gql-example-panel\">\u003cpre>\u003ccode>\u003cspan class=\"kw\">curl\u003c/span> -X POST https://restapi.ordergroove.com/graphql/\u003cspan class=\"nu\">2026\u003c/span>-\u003cspan class=\"nu\">01\u003c/span>/ \\\n  -H \u003cspan class=\"st\">&quot;X-API-KEY: &lt;your-api-key&gt;&quot;\u003c/span> \\\n  -H \u003cspan class=\"st\">&quot;Content-Type: application/json&quot;\u003c/span> \\\n  -d \u003cspan class=\"st\">&#x27;{&quot;query&quot;: &quot;query { orders(subscription: \\&quot;sub123\\&quot;, first: 25) { edges { node { publicId status subTotal total place created items { nodes { publicId quantity price totalPrice product { name externalProductId sku } subscription { publicId every everyPeriod } } } } } } }&quot;}&#x27;\u003c/span>\u003c/code>\u003c/pre>\u003c/div>\n\u003cdiv class=\"gql-example-panel\">\u003cpre>\u003ccode>\u003cspan class=\"kw\">const\u003c/span> query = \u003cspan class=\"st\">`\nquery {\n  orders(subscription: &quot;sub123&quot;, first: 25) {\n    edges {\n      node {\n        publicId\n        status\n        subTotal\n        total\n        place\n        created\n        items {\n          nodes {\n            publicId\n            quantity\n            price\n            totalPrice\n            product {\n              name\n              externalProductId\n              sku\n            }\n            subscription {\n              publicId\n              every\n              everyPeriod\n            }\n          }\n        }\n      }\n    }\n  }\n}\n`\u003c/span>;\n\n\u003cspan class=\"kw\">const\u003c/span> response = \u003cspan class=\"kw\">await\u003c/span> fetch(\n  \u003cspan class=\"st\">&quot;https://restapi.ordergroove.com/graphql/2026-01/&quot;\u003c/span>,\n  {\n    method: \u003cspan class=\"st\">&quot;POST&quot;\u003c/span>,\n    headers: {\n      \u003cspan class=\"st\">&quot;X-API-KEY: &lt;your-api-key&gt;&quot;\u003c/span>,\n      \u003cspan class=\"st\">&quot;Content-Type&quot;\u003c/span>: \u003cspan class=\"st\">&quot;application/json&quot;\u003c/span>,\n    },\n    body: JSON.stringify({ query }),\n  }\n);\n\n\u003cspan class=\"kw\">const\u003c/span> data = \u003cspan class=\"kw\">await\u003c/span> response.json();\u003c/code>\u003c/pre>\u003c/div>\n\u003cdiv class=\"gql-example-panel\">\u003cpre>\u003ccode>\u003cspan class=\"kw\">import\u003c/span> requests\n\nquery = \u003cspan class=\"st\">&quot;&quot;&quot;\nquery {\n  orders(subscription: &quot;sub123&quot;, first: 25) {\n    edges {\n      node {\n        publicId\n        status\n        subTotal\n        total\n        place\n        created\n        items {\n          nodes {\n            publicId\n            quantity\n            price\n            totalPrice\n            product {\n              name\n              externalProductId\n              sku\n            }\n            subscription {\n              publicId\n              every\n              everyPeriod\n            }\n          }\n        }\n      }\n    }\n  }\n}\n&quot;&quot;&quot;\u003c/span>\n\nresponse = requests.post(\n    \u003cspan class=\"st\">&quot;https://restapi.ordergroove.com/graphql/2026-01/&quot;\u003c/span>,\n    headers={\n        \u003cspan class=\"st\">&quot;X-API-KEY: &lt;your-api-key&gt;&quot;\u003c/span>,\n        \u003cspan class=\"st\">&quot;Content-Type&quot;\u003c/span>: \u003cspan class=\"st\">&quot;application/json&quot;\u003c/span>,\n    },\n    json={\u003cspan class=\"st\">&quot;query&quot;\u003c/span>: query},\n)\n\ndata = response.json()\u003c/code>\u003c/pre>\u003c/div>\n\u003c/div>\n\u003c/div>\n\u003c/div>\n      \u003c/div>\n    \u003c/div>\n\n  \u003c/div>\n\n\u003c/div>","type":"html"},"links":{"project":"/projects/me"},"privacy":{"view":"public"},"metadata":{"description":null,"keywords":null,"title":null,"image":{"uri":null,"url":null}}},"meta":{"baseUrl":"/","description":"","hidden":false,"image":[],"metaTitle":"Orders","slug":"graphql-orders","title":"Orders","type":"page"},"rdmd":{"dehydrated":{"toc":"","body":""},"opts":{"alwaysThrow":false,"compatibilityMode":false,"copyButtons":true,"correctnewlines":false,"markdownOptions":{"fences":true,"commonmark":true,"gfm":true,"ruleSpaces":false,"listItemIndent":"1","spacedTable":true,"paddedTable":true},"lazyImages":true,"normalize":true,"safeMode":false,"settings":{"position":false},"theme":"light","opts":{"resourceID":"/branches/2.10.0/custom_pages/graphql-orders","resourceType":"page"},"components":{},"baseUrl":"/","terms":[],"variables":{"user":{},"defaults":[{"name":"x-api-key","default":"5Yqx6wYK6sEnSdXbrQq4tj3N5yiFxE6JWQkdMvFcV8U4yCFjYub1ha4nEi48kGmMUhT5855Z1ecyW7fvVUAhLrJC","source":"","type":"","_id":"6962d00603bf8adacb9eabdf"},{"name":"X-OG-API-VERSION","default":"2","source":"","type":"","_id":"6962d00603bf8adacb9eabe0"},{"file":"ordergroove-webhooks-api.json","name":"api_key","source":"security","type":"apiKey","_id":"6965000c64e723272ef627ab"}]}}},"sidebar":[],"aiConfig":{"enabled":false,"settings":{"errors":null,"styleguide":null,"warnings":null}},"config":{"algoliaIndex":"readme_search_v2","amplitude":{"apiKey":"dc8065a65ef83d6ad23e37aaf014fc84","enabled":true},"api":{"upload":{"fileSizeLimit":10485760,"fileSizeLimitFormatted":"10MB"}},"asset_url":"https://cdn.readme.io","dashDomain":"dash.readme.com","domain":"readme.io","domainFull":"https://dash.readme.com","encryptedLocalStorageKey":"ekfls-2025-03-27","fullstory":{"enabled":true,"orgId":"FSV9A"},"git":{"preview":"https://githug-prod.gitto.rdme.io","sync":{"bitbucket":{"installationLink":"https://developer.atlassian.com/console/install/310151e6-ca1a-4a44-9af6-1b523fea0561?signature=AYABeMn9vqFkrg%2F1DrJAQxSyVf4AAAADAAdhd3Mta21zAEthcm46YXdzOmttczp1cy13ZXN0LTI6NzA5NTg3ODM1MjQzOmtleS83MDVlZDY3MC1mNTdjLTQxYjUtOWY5Yi1lM2YyZGNjMTQ2ZTcAuAECAQB4IOp8r3eKNYw8z2v%2FEq3%2FfvrZguoGsXpNSaDveR%2FF%2Fo0BHUxIjSWx71zNK2RycuMYSgAAAH4wfAYJKoZIhvcNAQcGoG8wbQIBADBoBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDOJgARbqndU9YM%2FRdQIBEIA7unpCah%2BIu53NA72LkkCDhNHOv%2BgRD7agXAO3jXqw0%2FAcBOB0%2F5LmpzB5f6B1HpkmsAN2i2SbsFL30nkAB2F3cy1rbXMAS2Fybjphd3M6a21zOmV1LXdlc3QtMTo3MDk1ODc4MzUyNDM6a2V5LzQ2MzBjZTZiLTAwYzMtNGRlMi04NzdiLTYyN2UyMDYwZTVjYwC4AQICAHijmwVTMt6Oj3F%2B0%2B0cVrojrS8yZ9ktpdfDxqPMSIkvHAGT%2FMTvCxC3XwnwlulZe975AAAAfjB8BgkqhkiG9w0BBwagbzBtAgEAMGgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMMUUe9d1YmFOo373TAgEQgDuJo7TayM6NL19Sj9RPooRrl8rYxwKgvu9gkLNc3GuyyovWI1xA2qTr0LQzMRsf3imrAWsywzPcsjnvuAAHYXdzLWttcwBLYXJuOmF3czprbXM6dXMtZWFzdC0xOjcwOTU4NzgzNTI0MzprZXkvNmMxMjBiYTAtNGNkNS00OTg1LWI4MmUtNDBhMDQ5NTJjYzU3ALgBAgIAeLKa7Dfn9BgbXaQmJGrkKztjV4vrreTkqr7wGwhqIYs5AZR28Sibv2eBxSIg2MydtvEAAAB%2BMHwGCSqGSIb3DQEHBqBvMG0CAQAwaAYJKoZIhvcNAQcBMB4GCWCGSAFlAwQBLjARBAzzWhThsIgJwrr%2FY2ECARCAOxoaW9pob21lweyAfrIm6Fw7gd8D%2B%2F8LHk4rl3jjULDM35%2FVPuqBrqKunYZSVCCGNGB3RqpQJr%2FasASiAgAAAAAMAAAQAAAAAAAAAAAAAAAAAEokowLKsF1tMABEq%2BKNyJP%2F%2F%2F%2F%2FAAAAAQAAAAAAAAAAAAAAAQAAADJLzRcp6MkqKR43PUjOiRxxbxXYhLc6vFXEutK3%2BQ71yuPq4dC8pAHruOVQpvVcUSe8dptV8c7wR8BTJjv%2F%2FNe8r0g%3D&product=bitbucket"}}},"metrics":{"billingCronEnabled":"true","dashUrl":"https://m.readme.io","defaultUrl":"https://m.readme.io","exportMaxRetries":12,"wsUrl":"wss://m.readme.io"},"micro":{"baseUrl":"https://micro-beta.readme.com"},"novuNotification":{"appId":"ob_MiAPOPqgP"},"proxyUrl":"https://try.readme.io","readmeRecaptchaSiteKey":"6LesVBYpAAAAAESOCHOyo2kF9SZXPVb54Nwf3i2x","releaseVersion":"5.715.0","reservedWords":{"tools":["execute-request","get-endpoint","get-server-variables","list-endpoints","list-specs","search-endpoints","search","fetch"]},"sentry":{"dsn":"https://3bbe57a973254129bcb93e47dc0cc46f@o343074.ingest.sentry.io/2052166","enabled":true},"shMigration":{"promoVideo":"","forceWaitlist":false,"migrationPreview":false},"sslBaseDomain":"readmessl.com","sslGenerationService":"ssl.readmessl.com","stripePk":"pk_live_5103PML2qXbDukVh7GDAkQoR4NSuLqy8idd5xtdm9407XdPR6o3bo663C1ruEGhXJjpnb2YCpj8EU1UvQYanuCjtr00t1DRCf2a","superHub":{"newProjectsEnabled":true},"wootric":{"accountToken":"NPS-122b75a4","enabled":true}},"context":{"labs":{},"user":{"isAuthenticated":false,"notifications":{}},"terms":[],"variables":{"user":{},"defaults":[{"name":"x-api-key","default":"5Yqx6wYK6sEnSdXbrQq4tj3N5yiFxE6JWQkdMvFcV8U4yCFjYub1ha4nEi48kGmMUhT5855Z1ecyW7fvVUAhLrJC","source":"","type":"","_id":"6962d00603bf8adacb9eabdf"},{"name":"X-OG-API-VERSION","default":"2","source":"","type":"","_id":"6962d00603bf8adacb9eabe0"},{"file":"ordergroove-webhooks-api.json","name":"api_key","source":"security","type":"apiKey","_id":"6965000c64e723272ef627ab"}]},"project":{"_id":"5d63dabecc03470056f9c570","accessRules":{"branch_merge":{"admin":true,"editor":false},"branch_approve":{"admin":true,"editor":false}},"ai":{"chat":{"knowledge":{"custom_knowledge":null,"use_project_knowledge":false},"models":[]}},"appearance":{"nextStepsLabel":"","hideTableOfContents":false,"showVersion":false,"html_hidelinks":false,"global_landing_page":{"redirect":"","html":""},"html_footer_meta":"\u003cscript>\n    // workaround to make the nav links open in a new tab\n\t\tsetTimeout(() => {\n        document.querySelector(\"#ssr-main > div > div.SuperHub2RNxzk6HzHiJ > div > div.ContentWithOwlbot-content2X1XexaN8Lf2 > header > div.Header-bottom2eLKOFXMEmh5.Header-bottom_compact.rm-Header-bottom.Header-bottom_withOwlbot3wuKp8NLXCqs > div > nav > a:nth-child(6)\").setAttribute(\"target\", \"_blank\");\n        document.querySelector(\"#ssr-main > div > div.SuperHub2RNxzk6HzHiJ > div > div.ContentWithOwlbot-content2X1XexaN8Lf2 > header > div.Header-bottom2eLKOFXMEmh5.Header-bottom_compact.rm-Header-bottom.Header-bottom_withOwlbot3wuKp8NLXCqs > div > nav > a:nth-child(7)\").setAttribute(\"target\", \"_blank\");\n    }, 3000);\n \u003c/script>","html_head":"\u003clink rel=\"alternate\" type=\"text/markdown\" href=\"current_url.md\">","html_footer":"","html_body":"","html_promo":"","javascript_hub2":"","javascript":"","stylesheet_hub2":"@import url('https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100;0,300;0,400;0,500;0,700;0,900;1,100;1,300;1,400;1,500;1,700;1,900&display=swap');\n/* Base CSS */\n\n@font-face {\n    font-family: \"Inter\";\n    src: url(\"https://use.typekit.net/af/59b013/00000000000000007735a1aa/30/l?primer=7cdcb44be4a7db8877ffa5c0007b8dd865b3bbc383831fe2ea177f62257a9191&fvd=n5&v=3\") format(\"woff2\"),url(\"https://use.typekit.net/af/59b013/00000000000000007735a1aa/30/d?primer=7cdcb44be4a7db8877ffa5c0007b8dd865b3bbc383831fe2ea177f62257a9191&fvd=n5&v=3\") format(\"woff\"),url(\"https://use.typekit.net/af/59b013/00000000000000007735a1aa/30/a?primer=7cdcb44be4a7db8877ffa5c0007b8dd865b3bbc383831fe2ea177f62257a9191&fvd=n5&v=3\") format(\"opentype\");\n    font-display: auto;\n    font-style: normal;\n    font-weight: 500;\n    font-stretch: normal;\n}\n\n@font-face {\n    font-family: \"InterSemibold\";\n    src: url(\"https://use.typekit.net/af/3ec29d/00000000000000007735a1b1/30/l?primer=7cdcb44be4a7db8877ffa5c0007b8dd865b3bbc383831fe2ea177f62257a9191&fvd=n4&v=3\") format(\"woff2\"),url(\"https://use.typekit.net/af/3ec29d/00000000000000007735a1b1/30/d?primer=7cdcb44be4a7db8877ffa5c0007b8dd865b3bbc383831fe2ea177f62257a9191&fvd=n4&v=3\") format(\"woff\"),url(\"https://use.typekit.net/af/3ec29d/00000000000000007735a1b1/30/a?primer=7cdcb44be4a7db8877ffa5c0007b8dd865b3bbc383831fe2ea177f62257a9191&fvd=n4&v=3\") format(\"opentype\");\n    font-display: auto;\n    font-style: normal;\n    font-weight: 400;\n    font-stretch: normal;\n}\n\n@font-face {\n    font-family: \"InterSemibold\";\n    src: url(\"https://use.typekit.net/af/fd801b/00000000000000007735a1b6/30/l?primer=7cdcb44be4a7db8877ffa5c0007b8dd865b3bbc383831fe2ea177f62257a9191&fvd=n6&v=3\") format(\"woff2\"),url(\"https://use.typekit.net/af/fd801b/00000000000000007735a1b6/30/d?primer=7cdcb44be4a7db8877ffa5c0007b8dd865b3bbc383831fe2ea177f62257a9191&fvd=n6&v=3\") format(\"woff\"),url(\"https://use.typekit.net/af/fd801b/00000000000000007735a1b6/30/a?primer=7cdcb44be4a7db8877ffa5c0007b8dd865b3bbc383831fe2ea177f62257a9191&fvd=n6&v=3\") format(\"opentype\");\n    font-display: auto;\n    font-style: normal;\n    font-weight: 600;\n    font-stretch: normal;\n}\n\n@font-face {\n    font-family: \"InterBold\";\n    src: url(\"https://use.typekit.net/af/5d2da8/00000000000000007735a1ac/30/l?primer=7cdcb44be4a7db8877ffa5c0007b8dd865b3bbc383831fe2ea177f62257a9191&fvd=n7&v=3\") format(\"woff2\"),url(\"https://use.typekit.net/af/5d2da8/00000000000000007735a1ac/30/d?primer=7cdcb44be4a7db8877ffa5c0007b8dd865b3bbc383831fe2ea177f62257a9191&fvd=n7&v=3\") format(\"woff\"),url(\"https://use.typekit.net/af/5d2da8/00000000000000007735a1ac/30/a?primer=7cdcb44be4a7db8877ffa5c0007b8dd865b3bbc383831fe2ea177f62257a9191&fvd=n7&v=3\") format(\"opentype\");\n    font-display: auto;\n    font-style: normal;\n    font-weight: 700;\n    font-stretch: normal;\n}\n\n.hub-is-home .rm-Header {\n  display: none !important;\n}\n\n*{\n    margin: 0;\n    padding: 0;\n    box-sizing: border-box;\n}\n\n/* Nav Menu Icons */\n#ssr-main > div > div.SuperHub2RNxzk6HzHiJ > div > div.ContentWithOwlbot-content2X1XexaN8Lf2 > header > div.Header-bottom2eLKOFXMEmh5.Header-bottom_compact.rm-Header-bottom.Header-bottom_withOwlbot3wuKp8NLXCqs > div > nav > a:nth-child(6) > span,\n#ssr-main > div > div.SuperHub2RNxzk6HzHiJ > div > div.ContentWithOwlbot-content2X1XexaN8Lf2 > header > div.Header-bottom2eLKOFXMEmh5.Header-bottom_compact.rm-Header-bottom.Header-bottom_withOwlbot3wuKp8NLXCqs > div > nav > a:nth-child(7) > span {\n    position: relative;\n    padding-right: 20px;\n}\n\nheader div > nav > a[href^=\"https://\"] > span::before {\n    content: ' ';\n    position: absolute;\n    display: block;\n    right: 0;\n    top: 2px;\n    background-image: url(\"data:image/svg+xml,\u003csvg width='16' height='16' viewBox='0 0 16 16' fill='none' xmlns='http://www.w3.org/2000/svg'>\u003cpath d='M7.25 2H4.25C3.00736 2 2 3.00735 2 4.24999V11.75C2 12.9926 3.00736 14 4.25 14H11.75C12.9926 14 14 12.9926 14 11.75V8.74996M10.2496 2.00018L14 2M14 2V5.37507M14 2L7.62445 8.37478' stroke-width='1.5' stroke-linecap='round' stroke='%2317132f' stroke-linejoin='round'/>\u003c/svg>\");\n    height: 16px;\n    width: 16px;\n}\n\n[data-color-mode=dark] header div > nav > a:nth-child(6) > span::before,\n[data-color-mode=dark] header div > nav > a:nth-child(7) > span::before {\n    background-image: url('data:image/svg+xml,\u003csvg width=\"16\" height=\"16\" viewBox=\"0 0 16 16\" fill=\"none\" xmlns=\"http://www.w3.org/2000/svg\"> \u003cpath d=\"M7.25 2H4.25C3.00736 2 2 3.00735 2 4.24999V11.75C2 12.9926 3.00736 14 4.25 14H11.75C12.9926 14 14 12.9926 14 11.75V8.74996M10.2496 2.00018L14 2M14 2V5.37507M14 2L7.62445 8.37478\" stroke=\"white\" stroke-width=\"1.5\" stroke-linecap=\"round\" stroke-linejoin=\"round\"/> \u003c/svg>');\n}\n\n.rm-Sidebar-heading {\n  font-size: 14px !important;\n    color: #17132f !important;\n}\n\n.rm-Sidebar-link {\n    color: #514e63 !important;\n}\n\n.rm-Sidebar-link.active {\n    color: #188c48 !important;\n}\n\n[data-color-mode=dark] .rm-Sidebar-heading {\n    color: white !important;\n}\n\n[data-color-mode=dark] .rm-Sidebar-link {\n    color: #c7c6cd !important;\n}\n\n[data-color-mode=dark] .rm-Sidebar-link.active {\n    color: #51e18d !important;\n}\n\n[data-color-mode=dark] .rm-SearchToggle {\n    background-color: #17132f !important;\n}\n\n.alignleft {\n    float: left;\n    margin-right: 15px;\n}\n\n.alignright {\n    float: right;\n    margin-left: 15px;\n}\n\n.aligncenter {\n    display: block;\n    margin: 0 auto 15px;\n}\n\na:focus {\n    outline: 0 solid\n}\n\nimg {\n    max-width: 100%;\n    height: auto;\n}\n\nh1,\nh2,\nh3,\nh4,\nh5,\nh6 {\n    margin: 0 0 15px;\n    font-family: 'Inter', Roboto;\n    margin-bottom: 15px;\n}\n\nbody {\n      color: #2D2D2D;\n    font-weight: 400;\n    font-family: \"Inter\", sans-serif;\n    line-height: 1.428;\n}\n\n[data-color-mode=dark] body {\n    background-color: #17132F;\n}\n\n\n[data-color-mode=dark] header.rm-Header {\n  background-color: #131024;\n}\n\n.selector-for-some-widget {\n    box-sizing: content-box;\n}\n  a.custom--btn:hover,\n  .card-btn a:hover {\n      text-decoration: none !important;\n  }\n\n  a,\n  button,\n  input,\n  textarea {\n      outline: none !important;\n\n  }\n  a, button{\n      border: none;\n      text-decoration: none;\n  }\n\n  p{\n      margin-bottom: 15px;\n  }\n\n.section-padding {\n    padding: 80px 0;\n}\n\n.rm-LandingPage {\n  width: 100%;\n  min-width: 100%;\n  padding: 0;\n}\n\n.home-container {\n    width: 1200px;\n    padding: 0 15px;\n    margin: 0 auto;\n}\n\n.header-wrapper {\n    display: flex;\n    align-items: center;\n    justify-content: space-between;\n}\n.header-left {\n    width: 40%;\n}\n.header-right {\n    width: 60%;\n}\n.logo a {\n    display: inline-block;\n}\n.logo a img {\n    max-height: 32px;\n}\n.logo a {\n    display: inline-block;\n    line-height: 1;\n}\n\n.logo a img {\n    max-height: 32px;\n}\n\n.header-menu ul {\n    margin: 0;\n    padding: 0;\n    list-style: none;\n    position: relative;\n    top: -3px;\n}\n\n.header-menu ul li {\n    display: inline-block;\n    margin-right: 40px;\n}\n\n.header-menu ul li a {\n    display: inline-block;\n    color: #fff;\n    font-size: 14px;\n    letter-spacing: .3px;\n    transition: .3s;\n    font-family: 'Inter', Roboto;\n}\n.header-menu ul li a:hover{\n    color: #00FF85;\n}\n\n.header-area {\n  background: #17132F;\n  position: absolute;\n  left: 0;\n  top: 0;\n  width: 100%;\n  z-index: 99;\n  transition: .3s;\n  padding: 30px 0;\n}\n.hero-area {\n    background: #17132F;\n    height: 850px;\n    display: flex;\n    align-items: center;\n    padding-top: 90px;\n    overflow: hidden;\n    position: relative;\n    z-index: 1;\n}\n.hero-wrapper {\n    display: flex;\n    align-items: center;\n    justify-content: space-between;\n}\n.hero__text h1 {\n    font-family: 'Inter', Roboto;\n    font-size: 65px;\n    color: #fff;\n    line-height: 130%;\n    letter-spacing: -2px;\n    margin-bottom: 20px;\n}\n.hero__text {\n    max-width: 660px;\n}\n.hero-left {\n    width: 60%;\n}\n.hero-right {\n    width: 40%;\n    text-align: right;\n}\n.hero-right img {\n    width: 100%;\n    position: relative;\n    top: -30px;\n}\n\n.gradient__text{\n    display: inline-block;\n    background: linear-gradient(to right top, #00fe8f, #00ffb4, #00ffd4, #00fdec, #01fafe);\n    -webkit-background-clip: text;\n    -webkit-text-fill-color: transparent;\n}\n.hero__text p {\n    font-size: 21px;\n    color: #FFFFFF;\n    font-weight: normal;\n    line-height: 150%;\n} \n.hero__btn {\n    margin-top: 40px;\n}\n\n.custom--btn  {\n    border: 1px solid #00FF85;\n    color: #000 !important;\n    text-decoration: none;\n    display: inline-block;\n    padding: 11px 32px;\n    border-radius: 40px;\n    font-size: 18px;\n    font-family: 'Inter', Roboto;\n    line-height: 101%;\n    background: #00FF85;\n    padding-top: 14px;\n    transition: .3s;\n}\n.custom--btn:hover{\n    background-color: transparent;\n    color: #00FF85 !important;\n}\n.hero-shp {\n    position: absolute;\n    right: 0;\n    bottom: -78%;\n    z-index: -1;\n    width: 1000px;\n}\nimg.hero-shp-2 {\n    position: absolute;\n    left: 0;\n    width: 65%;\n    top: 90px;\n    z-index: -2;\n}\n.brand-wrapper {\n    display: flex;\n    align-items: center;\n    justify-content: space-between;\n    gap: 0 10px;\n}\n.brand-item {\n    max-height: 95px;\n    display: flex;\n    align-items: center;\n    justify-content: center;\n    padding: 5px 5px;\n}\n.brand-area {\n    background: #FFFFFF;\n    padding: 15px 0;\n}\n\n.get-started-area {\n    padding: 90px 0;\n    background: #F5FFF9;\n    position: relative;\n}\n.area-title {\n    margin-bottom: 40px;\n    text-align: center;\n}\n.area-title h2 {\n    color: #000000;\n    font-size: 38px;\n    font-family: 'Inter', Roboto;\n}\n.about-card {\n    position: relative;\n    padding: 40px 30px;\n    height: 355px;\n    display: flex;\n    align-items: center;\n    justify-content: center;\n    text-align: center;\n    border-radius: 20px;\n    z-index: 1;\n    box-shadow: 0px 16px 8px 0px rgba(23, 19, 47, 0.1);\n    max-width: 360px;\n    margin: 0 auto;\n    transition: .3s;\n}\n.about-card:before {\n    position: absolute;\n    left: 50%;\n    top: 50%;\n    content: '';\n    z-index: -2;\n    background: #fff;\n    border-radius: 19px;\n    transform: translate(-50%, -50%);\n    height: calc(100% - 5px);\n    width: calc(100% - 5px);\n}\n.about-card:after {\n    position: absolute;\n    left: 0;\n    top: 0;\n    width: 100%;\n    height: 100%;\n    background-image: linear-gradient(to right bottom, #00faff, #00daff, #00b3ff, #007fff, #8500ff);\n    content: '';\n    border-radius: 20px;\n    z-index: -3;\n}\n.icon-bg {\n    position: absolute;\n    left: 0;\n    height: 100%;\n    top: 0;\n    width: 100%;\n    z-index: -1;\n}\n.icon-bg {\n    position: absolute;\n    left: 0;\n    height: 100%;\n    top: 0;\n    width: 100%;\n    z-index: -1;\n}\n.icon-box {\n    display: inline-flex;\n    align-items: center;\n    justify-content: center;\n    width: 82px;\n    height: 82px;\n    margin-bottom: 25px;\n    z-index: 1;\n    position: relative;\n    font-size: 0px;\n}\n.icon-box:before {\n  content: \"\";\n}\n.about-card-inner h2 {\n    font-size: 28px;\n    color: #2D2D2D;\n    font-weight: 600;\n}\n.about-card-inner p {\n  font-size: 16px;\n  color: #2D2D2D;\n  min-height: 72px;\n}\n.card-btn a {\n    display: inline-flex;\n    justify-content: center;\n    color: #8500FF;\n    font-size: 18px;\n    text-decoration: none;\n    align-items: center;\n    font-family: 'Inter', Roboto;\n    gap:0 10px\n}\n.card-wrapper {\n    display: grid;\n    grid-template-columns: repeat(3, calc(33.33% - 13px));\n    gap: 0 20px;\n}\n.card-btn img {\n    width: 18px;\n    position: relative;\n    top: -1px;\n}\n\n\n\n\n\n\n.subscription-area {\n    padding: 120px 0;\n    position: relative;\n}\n.subscription-wrapper {\n    padding: 40px;\n    position: relative;\n    border-radius: 30px 0 30px 30px;\n    position: relative;\n    z-index: 1;\n    padding-right: 0;\n    display: flex;\n    align-items: center;\n    justify-content: space-between;\n}\n.subscription-wrapper:after {\n    position: absolute;\n    left: 0;\n    top: 0;\n    width: calc(100% - 50px);\n    background: #17132F;\n    content: '';\n    height: 100%;\n    z-index: -1;\n    border-radius: 30px 0 30px 30px;\n}\n.subscription-content {\n    padding-left: 10px;\n    width: 60%;\n}\n.subscription-thumb {\n    text-align: right;\n    width: 40%;\n}\n.subscription-thumb img {\n    max-width: 420px;\n}\n.subscription-content h5 {\n    display: block;\n    color: #00FF85;\n    font-size: 14px;\n    text-transform: uppercase;\n    letter-spacing: .3px;\n}\n.subscription-content h2 {\n    color: #fff;\n    line-height: 125%;\n    font-size: 30px;\n    font-family: 'Inter', Roboto;\n}\n.subscription-content p {\n    max-width: 450px;\n    color: #fff;\n}\n.partner-btn {\n    margin-top: 30px;\n}\n\n.gradient-text-two{\n    display: inline-block;\n    background-image: linear-gradient(to right, #19eba1, #00d4db, #00b4ff, #0088ff, #782bf6);\n    -webkit-background-clip: text;\n    -webkit-text-fill-color: transparent;\n}\n\n/* XL Device :1200px. */\n@media (min-width: 1200px) and (max-width: 1449px) {\n    .hero-area {\n        height: 780px;\n    }\n\n    img.hero-shp-2 {\n        width: 60%;\n        top: 80px;\n    }\n\n    .hero-shp {\n        bottom: -82%;\n        width: 905px;\n    }\n\n\n\n\n}\n\n\n\n\n@media (min-width: 1200px) and (max-width: 1300px) {\n    .hero-area {\n        height: 760px;\n    }\n\n    .hero-shp {\n        bottom: -85%;\n        width: 880px;\n        right: -50px\n    }\n\n    .home-container {\n        width: 1170px;\n    }\n\n}\n\n\n\n\n\n\n\n/* LG Device :992px. */\n@media (min-width: 992px) and (max-width: 1200px) {\n    .home-container {\n        width: 100%;\n    }\n\n    .subscription-thumb img {\n        max-width: 360px;\n    }\n\n    .subscription-content {\n        padding-left: 15px;\n    }\n\n    .subscription-wrapper {\n        padding: 32px 20px;\n        padding-right: 0;\n    }\n\n    .custom--btn {\n        font-size: 16px;\n    }\n\n    .brand-item img {\n        max-height: 60px;\n    }\n\n    .hero-area {\n        height: 640px;\n        padding-top: 80px;\n    }\n\n    .hero__text h1 {\n        font-size: 55px;\n        line-height: 120%;\n    }\n\n    .hero__text p {\n        font-size: 19px;\n    }\n\n    .hero__btn {\n        margin-top: 35px;\n    }\n\n    .logo a img {\n        max-height: 28px;\n    }\n\n    .hero-shp {\n        bottom: -78%;\n        width: 760px;\n        right: -10%;\n    }\n\n    .icon-box {\n        width: 75px;\n        height: 74px;\n        margin-bottom: 20px;\n    }\n\n    .about-card {\n        padding: 28px 22px;\n        height: 320px;\n        border-radius: 16px;\n        max-width: 360px;\n    }\n\n    .about-card:before {\n        border-radius: 17px;\n    }\n\n    .about-card:after {\n        border-radius: 16px;\n    }\n\n    .about-card-inner h2 {\n        font-size: 24px;\n    }\n\n    .about-card-inner p {\n        font-size: 15px;\n    }\n\n    footer {\n        padding-top: 60px;\n        padding-bottom: 20px;\n    }\n\n\n\n\n\n\n}\n\n\n@media (min-width: 768px) and (max-width: 991px) {\n    .home-container {\n        width: 100%;\n    }\n\n    .header-menu ul li {\n        display: inline-block;\n        margin-right: 30px;\n    }\n\n    .logo a img {\n        max-height: 25px;\n    }\n\n    .logo {\n        text-align: right;\n    }\n    .subscription-thumb img {\n        max-width: 100%;\n        width: 100%;\n    }\n    .subscription-content {\n        padding-left: 0;\n        width: 60%;\n        padding-right: 25px;\n    }\n    .subscription-wrapper {\n        padding: 30px;\n        padding-right: 0;\n    }\n    .subscription-content h2 {\n        font-size: 22px;\n    }\n    .subscription-content p {\n        font-size: 14px;\n    }\n    .custom--btn {\n        padding: 10px 28px;\n        border-radius: 40px;\n        font-size: 15px;\n        line-height: 101%;\n        padding-top: 13px;\n    }\n    .hero__text h1 {\n        font-size: 45px;\n    }\n    .hero__text p {\n        font-size: 16px;\n    }\n    .hero__btn {\n        margin-top: 30px;\n    }\n    .hero-area {\n        height: 550px;\n        padding-top: 70px;\n    }\n    .hero-shp {\n        right: -14%;\n        bottom: -77%;\n        width: 600px;\n    }\n    img.hero-shp-2 {\n        width: 60%;\n        top: 77px;\n    }\n    .about-card {\n        padding: 25px 15px;\n        height: 280px;\n    }\n    .icon-box {\n        width: 64px;\n        height: 64px;\n        margin-bottom: 15px;\n    }\n    .about-card-inner h2 {\n        font-size: 20px;\n        margin-bottom: 10px;\n    }\n    .about-card-inner p {\n        font-size: 14px;\n    }\n    .card-btn a {\n        font-size: 15px;\n        gap: 0 8px;\n    }\n    .area-title h2 {\n        font-size: 30px;\n    }\n    .icon-bg {\n        position: absolute;\n        left: 0;\n        height: 100%;\n        top: 0;\n        width: 100%;\n        z-index: -1;\n    }\n    .icon-box img:first-child {\n        width: 36px;\n    }\n    .subscription-area {\n        padding: 80px 0;\n    }\n    .footer-logo img {\n        max-height: 28px;\n    }\n    .subscription-box {\n        height: 38px;\n    }\n    \n\n\n}\n\n\n\n\n/* SM Small Device :320px. */\n@media only screen and (max-width: 767px) {\n    .brand-wrapper {\n        gap: 20px 10px;\n        flex-wrap: wrap;\n    }\n    .brand-item {\n        height: 140px;\n        padding: 5px 5px;\n        display: flex;\n        align-items: center;\n        justify-content: center;\n        margin-bottom: 20px;\n    }\n    .card-wrapper {\n        display: grid;\n        grid-template-columns: repeat(1, calc(100%));\n        gap: 0 20px;\n    }\n    .about-card{\n        margin-bottom: 25px;\n    }\n    .footer-wrapper {\n        display: block; \n    }\n    .home-container {\n        width: 100%;\n        padding: 0 15px;\n        margin: 0 auto;\n    }\n    .subscription-thumb img {\n        max-width: 100%;\n    }\n    .subscription-thumb {\n        display: none;\n    }\n    .subscription-content {\n        padding-left: 0;\n        width: 100%;\n    }\n    .subscription-wrapper:after {\n        width: 100%;\n        height: 100%;\n        z-index: -1;\n        border-radius: 16px;\n    }\n    .subscription-wrapper:after {\n        border-radius: 40px;\n        padding: 035px 25px;\n    }\n    .subscription-content h2 {\n        font-size: 20px;\n    }\n    .subscription-content h2 {\n        color: #fff;\n        font-size: 20px;\n        font-family: 'Inter';\n    }\n    .logo a img {\n        max-height: 20px;\n    }\n    .header-menu ul li {\n        margin-right: 12px;\n    }\n    .header-menu ul li a {\n        font-size: 13px;\n    }\n    .hero__text h1 {\n        font-size: 28px;\n    }\n    .hero-wrapper {\n        display: block;\n    }\n    .hero-left {\n        width: 100%;\n    }\n    .hero-area {\n        height: auto;\n        padding-top: 70px;\n        padding-bottom: 70px;\n    }\n    .hero-wrapper {\n        text-align: center;\n    }\n    .hero-right img {\n        width: 320px;\n        position: relative;\n        top: 0;\n    }\n    .hero__text p {\n        font-size: 16px;\n    }\n    .hero-right {\n        width: 100%;\n        text-align: center;\n        margin-top: 50px;\n    }\n    .hero-right img {\n        width: 200px;\n        position: relative;\n    }\n\n    .header-left {\n        width: 85%;\n    }\n    .logo {\n        text-align: right;\n    }\n    .header-right {\n        width: 40%;\n    }\n    .hero-wrapper {\n        display: flex;\n        flex-direction: column-reverse;\n    }\n    .hero-left {\n        margin-top: 50px;\n    }\n    .brand-item img {\n        max-height: 70px;\n    }\n    .brand-wrapper {\n        gap: 0 10px;\n        flex-wrap: wrap;\n    }\n    .brand-item {\n        padding: 5px 5px;\n        justify-content: center;\n        margin-bottom: 20px;\n    }\n    .brand-item {\n        padding: 9px 5px;\n        justify-content: center;\n        margin-bottom: 10px;\n    }\n    .brand-item img {\n        width: 70px;\n    }\n    .brand-item {\n        height: 69px;\n        padding: 5px 5px;\n        margin-bottom: 20px;\n    }\n    .brand-item {\n        height: 60px;\n    }\n    .get-started-area {\n        padding: 60px 0;\n    }\n    .subscription-wrapper {\n        padding: 30px;\n        z-index: 1;\n        padding-right: 0;\n        background: #000;\n        border-radius: 15px !important;\n    }\n    .subscription-wrapper:after {\n        border-radius: 40px;\n        width: 100%;\n    }\n    .subscription-area {\n        padding: 90px 0;\n    }\n    .footer-left {\n        width: 100%;\n        margin-bottom: 35px;\n    }\n    .footer-widget {\n        width: 100%;\n    }\n    .footer-right {\n        width: 100%;\n    }\n    .subscription-wrapper:after {\n        display: none;\n    }\n    .footer-right {\n        width: 100%;\n        display: block;\n    }\n    .footer-bottom-wrapper {\n        display: block;\n        text-align: center;\n    }\n    .social-links{\n        text-align: center;\n        margin-top: 25px;\n    }\n    .social-links {\n        display: flex;\n        justify-content: center;\n        align-items: center;\n        margin-top: 25px;\n    }\n    .footer-logo {\n        margin-bottom: 15px;\n        width: 150px;\n    }\n    .subscription-form{\n        display: block;\n    }\n    .footer-right {\n        margin-top: 50px;\n    }\n    .subscription-wrapper {\n        padding: 30px;\n        z-index: 1;\n        padding-right: 0;\n        background: #000;\n        border-radius: 15px !important;\n    }\n    .area-title h2 {\n        font-size: 28px;\n    }\n    .custom--btn {\n        padding-top: 14px;\n    }\n    .brand-item img {\n        width: 85px;\n    }\n\n}\n\n\n/* SM Small Device :550px. */\n@media only screen and (min-width: 576px) and (max-width: 767px) {}\n\n/* footer styles */\n.home-footer {\n    background: #17132F;\n    padding-top: 80px;\n    padding-bottom: 50px;\n\n    .subscription-form {\n        margin-top: 70px;\n    }\n    .subscription-form label {\n        color: #D8D7DF;\n        font-size: 10px;\n        margin-bottom: 10px;\n        font-family: 'Inter';\n        letter-spacing: .3px;\n    }\n    .subscription-box input {\n        width: 100%;\n        height: 100%;\n        border-radius: 40px;\n        border: none;\n        color: #666279;\n        padding: 8px 16px;\n        line-height: 1;\n        font-size: 12px;\n        font-family: 'Inter';\n    }\n    .subscription-box button {\n        position: absolute;\n        right: 12px;\n        top: 50%;\n        background: transparent;\n        border: none;\n        cursor: pointer;\n        transform: translateY(-50%);\n        padding: 0;\n        margin-top: -2px;\n    }\n    .footer-left-content {\n        max-width: 220px;\n    }\n    .footer-logo {\n        margin-bottom: 15px;\n    }\n    .footer-left-content p {\n        color: #ABA9BA;\n        font-size: 12px;\n        line-height: 130%;\n        font-family: 'Inter';\n    }\n    .subscription-box {\n        position: relative;\n        width: 220px;\n        height: 38px;\n    }\n    .subscription-form label {\n        color: #D8D7DF;\n        font-size: 10px;\n        margin-bottom: 10px;\n        font-family: 'Inter';\n        letter-spacing: .3px;\n        display: block;\n    }\n    .footer-widget h3 {\n        font-size: 14px;\n        color: #fff;\n        display: block;\n        padding-bottom: 10px;\n        border-bottom: 1px solid #4F4A6A;\n        max-width: 165px;\n        margin-bottom: 20px;\n    }\n    .footer-links {\n        margin-bottom: 35px;\n    }\n    .footer-links ul {\n        margin: 0;\n        padding: 0;\n        list-style: none;\n    }\n    .footer-links ul li {\n        display: block;\n        margin-bottom: 7px;\n        font-size: 12px;\n        color: #ABA9BA;\n    }\n    .footer-links ul li a {\n        display: block;\n        color: #ABA9BA;\n        text-decoration: none;\n        font-size: 12px;\n        letter-spacing: .3px;\n        transition: .3s;\n        font-family: 'Inter';\n    }\n    .footer-links li a:hover {\n        color: #00FF85;\n    }\n    .subtitle h4 {\n        font-size: 10px;\n        color: #EBEAF0;\n        text-transform: uppercase;\n        font-family: 'Inter';\n        margin-bottom: 12px;\n    }\n    .footer-left {\n        width: 32%;\n    }\n    .footer-right {\n        width: 68%;\n        display: flex;\n        gap: 0 15px;\n    }\n    .footer-wrapper {\n        display: flex;\n        justify-content: space-between;\n        align-items: flex-start;\n    }\n    .footer-widget {\n        width: 33.33%;\n    }\n    .copyright-text p {\n        color: #787688;\n        font-size: 12px;\n        letter-spacing: .2px;\n        margin: 0;\n        font-family: 'Inter';\n    }\n    .social-links {\n        display: flex;\n        justify-content: flex-end;\n        align-items: center;\n    }\n    .social-links ul {\n        margin: 0;\n        padding: 0;\n        list-style: none;\n    }\n    .social-links ul li {\n        display: inline-block;\n        margin-left: 10px;\n    }\n    .social-links ul li a {\n        display: inline-flex;\n        width: 33px;\n        height: 33px;\n        background: #2E2A47;\n        align-items: center;\n        justify-content: center;\n        border-radius: 100%;\n        transition: .3s;\n        border: 1px solid #2E2A47;\n    }\n    .footer-bottom-wrapper {\n        padding-top: 25px;\n        padding-bottom: 10px;\n        border-top: 1px solid #2E2A47;\n        display: flex;\n        align-items: center;\n        justify-content: space-between;\n        gap: 0 15px;\n    }\n    \n    .subscription-box button {\n        position: absolute;\n        right: 12px;\n        top: 50%;\n        background: transparent;\n        border: none;\n        cursor: pointer;\n        transform: translateY(-50%);\n        padding: 0;\n        margin-top: 2px;\n    }\n}\n\n/* CUSTOM Changes\n\n/* Disable code wrapping and enable horizontal scroll */\n.markdown-body pre, \n.markdown-body pre > code {\n    white-space: pre !important;\n    overflow-x: auto !important;\n    word-break: normal !important;\n    word-wrap: normal !important;\n}\n\n/* 1. Prevent text from wrapping in all table cells */\n.rdmd-table th, \n.rdmd-table td {\n  white-space: nowrap !important;\n  padding: 12px 15px; /* Optional: adds some breathing room */\n}\n\n/* 2. Ensure the table container allows horizontal scrolling */\n.rdmd-table-inner {\n  overflow-x: auto !important;\n  display: block;\n  width: 100%;\n}\n\n\n/* ───────────────────────────────────────────────────────────────\n   GraphQL API Docs — Custom CSS for README.io\n   Paste this into: Appearance > Custom CSS/JS > Custom CSS\n   All rules scoped under .gql-docs to avoid conflicts.\n   ─────────────────────────────────────────────────────────────── */\n\n/* Align README.io page title with our full-width layout */\n.rm-CustomPage > div:has(.gql-docs) {\n  width: 100vw;\n  padding: 0 40px;\n  box-sizing: border-box;\n}\n\n.gql-docs {\n  --gql-border: #e1e3e5;\n  --gql-text: #1a1a1a;\n  --gql-text-muted: #616161;\n  --gql-text-link: #0057b8;\n  --gql-accent: #008060;\n  --gql-badge-required: #d72c0d;\n  --gql-badge-bg-required: #fef0ee;\n  --gql-font-mono: 'SF Mono', SFMono-Regular, Consolas, 'Liberation Mono', Menlo, monospace;\n  line-height: 1.6;\n  /* Break out of README.io's narrow container */\n  width: 100vw;\n  margin-left: calc(-50vw + 50%);\n  padding: 0 40px;\n  box-sizing: border-box;\n}\n\n/* ── Page title ── */\n.gql-docs h1 code {\n  font-family: var(--gql-font-mono);\n  font-weight: 600;\n  background: none;\n  padding: 0;\n}\n.gql-docs .gql-subtitle {\n  font-size: 15px;\n  color: var(--gql-text-muted);\n  margin-bottom: 24px;\n}\n.gql-docs .gql-description {\n  font-size: 15px;\n  line-height: 1.7;\n  margin-bottom: 24px;\n}\n.gql-docs .gql-description ul {\n  margin: 12px 0;\n  padding-left: 24px;\n}\n.gql-docs .gql-description li {\n  margin-bottom: 4px;\n}\n.gql-docs .gql-callout {\n  background: #f6f6f7;\n  border-left: 3px solid var(--gql-accent);\n  border-radius: 4px;\n  padding: 12px 16px;\n  font-size: 14px;\n  margin-bottom: 24px;\n  color: var(--gql-text-muted);\n}\n\n/* ── Section headings ── */\n.gql-docs .gql-section-heading {\n  font-size: 20px;\n  font-weight: 600;\n  margin-top: 40px;\n  margin-bottom: 16px;\n  padding-bottom: 8px;\n  border-bottom: 1px solid var(--gql-border);\n}\n\n/* ── Arguments ── */\n.gql-docs .gql-arg-list {\n  list-style: none;\n  margin: 0;\n  padding: 0;\n}\n.gql-docs .gql-arg-item {\n  padding: 12px 0;\n  border-bottom: 1px solid var(--gql-border);\n}\n.gql-docs .gql-arg-item:last-child {\n  border-bottom: none;\n}\n.gql-docs .gql-arg-header {\n  display: flex;\n  align-items: center;\n  gap: 8px;\n  margin-bottom: 4px;\n}\n.gql-docs .gql-arg-name {\n  font-family: var(--gql-font-mono);\n  font-size: 14px;\n  font-weight: 600;\n  color: var(--gql-text);\n}\n.gql-docs .gql-type-tag {\n  font-family: var(--gql-font-mono);\n  font-size: 13px;\n  color: var(--gql-text-link);\n}\n.gql-docs .gql-badge {\n  font-size: 11px;\n  font-weight: 600;\n  padding: 1px 6px;\n  border-radius: 3px;\n  text-transform: uppercase;\n  letter-spacing: 0.5px;\n  display: inline-block;\n}\n.gql-docs .gql-badge-required {\n  color: var(--gql-badge-required);\n  background: var(--gql-badge-bg-required);\n}\n.gql-docs .gql-badge-non-null {\n  color: var(--gql-accent);\n  background: #e3f4ef;\n}\n.gql-docs .gql-arg-desc {\n  font-size: 14px;\n  color: var(--gql-text-muted);\n}\n\n/* ── Field list ── */\n.gql-docs .gql-field-list {\n  list-style: none;\n  margin: 0;\n  padding: 0;\n}\n.gql-docs .gql-field-item {\n  border-bottom: 1px solid var(--gql-border);\n}\n.gql-docs .gql-field-row {\n  display: flex;\n  align-items: baseline;\n  gap: 8px;\n  padding: 10px 0;\n  flex-wrap: wrap;\n}\n.gql-docs .gql-field-name {\n  font-family: var(--gql-font-mono);\n  font-size: 14px;\n  font-weight: 600;\n  color: var(--gql-text);\n}\n.gql-docs .gql-field-desc {\n  font-size: 13px;\n  color: var(--gql-text-muted);\n  flex-basis: 100%;\n  margin-top: 2px;\n}\n\n/* ── Nested / expandable types ── */\n.gql-docs details.gql-nested-type {\n  border-bottom: 1px solid var(--gql-border);\n}\n.gql-docs details.gql-nested-type > summary {\n  display: flex;\n  align-items: center;\n  gap: 8px;\n  padding: 10px 0;\n  cursor: pointer;\n  list-style: none;\n  flex-wrap: wrap;\n}\n.gql-docs details.gql-nested-type > summary::-webkit-details-marker {\n  display: none;\n}\n.gql-docs details.gql-nested-type > summary::before {\n  content: '\\25B8';\n  font-size: 12px;\n  color: var(--gql-text-muted);\n  transition: transform 0.15s;\n  flex-shrink: 0;\n}\n.gql-docs details.gql-nested-type[open] > summary::before {\n  transform: rotate(90deg);\n}\n.gql-docs details.gql-nested-type > .gql-nested-content {\n  padding: 0 0 8px 20px;\n  border-left: 2px solid var(--gql-border);\n  margin-left: 4px;\n  margin-bottom: 8px;\n}\n.gql-docs .gql-nested-type-heading {\n  font-size: 13px;\n  font-weight: 600;\n  color: var(--gql-text-muted);\n  text-transform: uppercase;\n  letter-spacing: 0.5px;\n  margin-bottom: 4px;\n  padding-top: 4px;\n}\n.gql-docs .gql-show-fields {\n  font-size: 12px;\n  color: var(--gql-text-link);\n  margin-left: auto;\n}\n.gql-docs details.gql-nested-type[open] > summary .gql-show-fields {\n  display: none;\n}\n\n/* ── Left navigation ── */\n.gql-docs .gql-nav {\n  width: 200px;\n  flex-shrink: 0;\n}\n.gql-docs .gql-nav-inner {\n  position: sticky;\n  top: 20px;\n}\n.gql-docs .gql-nav-section {\n  border: none;\n}\n.gql-docs .gql-nav-section > summary {\n  font-size: 11px;\n  font-weight: 700;\n  text-transform: uppercase;\n  letter-spacing: 0.8px;\n  color: var(--gql-text-muted);\n  padding: 6px 0;\n  cursor: pointer;\n  list-style: none;\n}\n.gql-docs .gql-nav-section > summary::-webkit-details-marker {\n  display: none;\n}\n.gql-docs .gql-nav-list {\n  list-style: none;\n  margin: 0;\n  padding: 0;\n}\n.gql-docs .gql-nav-link {\n  display: block;\n  font-family: var(--gql-font-mono);\n  font-size: 13px;\n  padding: 5px 12px;\n  color: var(--gql-text-muted);\n  text-decoration: none;\n  border-radius: 4px;\n}\n.gql-docs a.gql-nav-link:hover {\n  color: var(--gql-text);\n  background: #f6f6f7;\n}\n.gql-docs .gql-nav-active {\n  color: var(--gql-text);\n  font-weight: 600;\n  background: #f0f0f0;\n}\n\n/* ── Three-column layout ── */\n.gql-docs .gql-layout {\n  display: flex;\n  gap: 32px;\n  align-items: flex-start;\n}\n.gql-docs .gql-main {\n  flex: 1;\n  min-width: 0;\n}\n.gql-docs .gql-sidebar {\n  width: 380px;\n  flex-shrink: 0;\n  min-width: 0;\n}\n.gql-docs .gql-sidebar-inner {\n  position: sticky;\n  top: 20px;\n  max-height: 90vh;\n  overflow-y: auto;\n}\n.gql-docs .gql-sidebar-label {\n  font-size: 12px;\n  font-weight: 600;\n  color: #a0a0a0;\n  text-transform: uppercase;\n  letter-spacing: 0.8px;\n  padding: 10px 16px 0;\n  background: #1e1e1e;\n  border-radius: 6px 6px 0 0;\n}\n.gql-docs .gql-sidebar-label:nth-of-type(n+2) {\n  margin-top: 16px;\n}\n@media (max-width: 900px) {\n  .gql-docs .gql-nav {\n    display: none;\n  }\n  .gql-docs .gql-sidebar {\n    display: none;\n  }\n  .gql-docs .gql-layout {\n    display: block;\n  }\n}\n\n/* ── Code blocks ── */\n.gql-docs pre {\n  background: #1e1e1e;\n  color: #d4d4d4;\n  border-radius: 0 0 6px 6px;\n  padding: 16px 20px;\n  font-family: var(--gql-font-mono);\n  font-size: 13px;\n  line-height: 1.5;\n  overflow-x: auto;\n  margin-top: 0;\n  margin-bottom: 0;\n}\n.gql-docs pre.gql-code-standalone {\n  border-radius: 6px;\n}\n.gql-docs pre .kw { color: #569cd6; }\n.gql-docs pre .fl { color: #9cdcfe; }\n.gql-docs pre .st { color: #ce9178; }\n.gql-docs pre .vr { color: #dcdcaa; }\n.gql-docs pre .cm { color: #6a9955; }\n.gql-docs pre .nu { color: #b5cea8; }\n.gql-docs pre .br { color: #808080; }\n.gql-docs .gql-response-label {\n  font-size: 12px;\n  font-weight: 600;\n  color: #a0a0a0;\n  text-transform: uppercase;\n  letter-spacing: 0.8px;\n  padding: 12px 16px 0;\n  background: #1e1e1e;\n  margin-top: 2px;\n}\n\n/* ── Example sidebar ── */\n.gql-docs .gql-examples {\n  margin-bottom: 24px;\n}\n.gql-docs .gql-example-header {\n  font-size: 14px;\n  font-weight: 600;\n  color: var(--gql-text);\n  margin-bottom: 8px;\n}\n.gql-docs .gql-example-desc {\n  font-size: 13px;\n  color: var(--gql-text-muted);\n  margin: 0 0 8px;\n}\n\n/* ── Example selector (pills) ── */\n.gql-docs .gql-ex-select {\n  display: none;\n}\n.gql-docs .gql-ex-select-label {\n  display: inline-block;\n  padding: 4px 10px;\n  font-size: 12px;\n  font-weight: 600;\n  cursor: pointer;\n  color: var(--gql-text-muted);\n  background: #f0f0f0;\n  border: 1px solid var(--gql-border);\n  border-radius: 12px;\n  margin: 0 4px 8px 0;\n  transition: all 0.15s;\n}\n.gql-docs .gql-ex-select:checked + .gql-ex-select-label {\n  color: #fff;\n  background: var(--gql-accent);\n  border-color: var(--gql-accent);\n}\n.gql-docs .gql-examples > .gql-example {\n  display: none;\n}\n.gql-docs .gql-examples > input.gql-ex-select:nth-of-type(1):checked ~ .gql-example:nth-of-type(1) { display: block; }\n.gql-docs .gql-examples > input.gql-ex-select:nth-of-type(2):checked ~ .gql-example:nth-of-type(2) { display: block; }\n.gql-docs .gql-examples > input.gql-ex-select:nth-of-type(3):checked ~ .gql-example:nth-of-type(3) { display: block; }\n.gql-docs .gql-examples > input.gql-ex-select:nth-of-type(4):checked ~ .gql-example:nth-of-type(4) { display: block; }\n\n/* ── CSS-only language tabs ── */\n.gql-docs .gql-example-tabs {\n  border-radius: 6px;\n  overflow: hidden;\n}\n.gql-docs .gql-example-tabs input[type=\"radio\"] {\n  display: none;\n}\n.gql-docs .gql-example-tabs label {\n  display: inline-block;\n  padding: 6px 12px;\n  font-size: 12px;\n  font-weight: 600;\n  cursor: pointer;\n  color: #a0a0a0;\n  background: #1e1e1e;\n  border-bottom: 2px solid transparent;\n  margin: 0;\n}\n.gql-docs .gql-example-tabs input[type=\"radio\"]:checked + label {\n  color: #fff;\n  border-bottom-color: #569cd6;\n}\n.gql-docs .gql-example-panel {\n  display: none;\n}\n.gql-docs .gql-example-panel pre {\n  border-radius: 0 0 6px 6px;\n  max-height: 60vh;\n  overflow-y: auto;\n  scrollbar-width: thin;\n  scrollbar-color: #555 #1e1e1e;\n}\n.gql-docs .gql-example-panel pre::-webkit-scrollbar {\n  width: 6px;\n}\n.gql-docs .gql-example-panel pre::-webkit-scrollbar-track {\n  background: #1e1e1e;\n}\n.gql-docs .gql-example-panel pre::-webkit-scrollbar-thumb {\n  background: #555;\n  border-radius: 3px;\n}\n.gql-docs pre code {\n  display: block;\n  color: inherit;\n  background: none;\n  padding: 0;\n  font-size: inherit;\n  user-select: all;\n}\n.gql-docs .gql-example-tabs input:nth-of-type(1):checked ~ div:nth-of-type(1) { display: block; }\n.gql-docs .gql-example-tabs input:nth-of-type(2):checked ~ div:nth-of-type(2) { display: block; }\n.gql-docs .gql-example-tabs input:nth-of-type(3):checked ~ div:nth-of-type(3) { display: block; }\n.gql-docs .gql-example-tabs input:nth-of-type(4):checked ~ div:nth-of-type(4) { display: block; }\n\n\n/* ── Cross-link sidebar (type pages) ── */\n.gql-docs .gql-crosslinks {\n  margin-bottom: 24px;\n}\n.gql-docs .gql-crosslinks-heading {\n  font-size: 11px;\n  font-weight: 700;\n  text-transform: uppercase;\n  letter-spacing: 0.8px;\n  color: var(--gql-text-muted);\n  margin-bottom: 12px;\n}\n.gql-docs .gql-crosslinks-list {\n  list-style: none;\n  margin: 0;\n  padding: 0;\n}\n.gql-docs .gql-crosslinks-list li {\n  padding: 8px 0;\n  border-bottom: 1px solid var(--gql-border);\n}\n.gql-docs .gql-crosslinks-list li:last-child {\n  border-bottom: none;\n}\n.gql-docs .gql-crosslink {\n  display: block;\n  font-size: 14px;\n  font-weight: 500;\n  color: var(--gql-text-link);\n  text-decoration: none;\n}\n.gql-docs a.gql-crosslink:hover {\n  text-decoration: underline;\n}\n.gql-docs .gql-crosslink-query {\n  display: block;\n  font-family: var(--gql-font-mono);\n  font-size: 12px;\n  color: var(--gql-text-muted);\n  margin-top: 2px;\n}\n.gql-docs .gql-crosslink-details {\n  margin-top: 6px;\n}\n.gql-docs .gql-crosslink-details summary {\n  font-size: 12px;\n  font-weight: 600;\n  color: var(--gql-text-link);\n  cursor: pointer;\n}\n.gql-docs .gql-crosslink-details[open] summary {\n  margin-bottom: 8px;\n}\n\n/* ── Dark mode (README.io explicit dark) ── */\n[data-color-mode=\"dark\"] .gql-docs {\n  --gql-border: #333;\n  --gql-text: #e0e0e0;\n  --gql-text-muted: #999;\n  --gql-text-link: #58a6ff;\n  --gql-accent: #3fb980;\n  --gql-badge-required: #f97583;\n  --gql-badge-bg-required: #3d1a1e;\n}\n[data-color-mode=\"dark\"] .gql-docs .gql-badge-non-null { background: #1a3a2a; }\n[data-color-mode=\"dark\"] .gql-docs .gql-callout { background: #1e1e1e; }\n[data-color-mode=\"dark\"] .gql-docs a.gql-nav-link:hover { background: #2a2a2a; }\n[data-color-mode=\"dark\"] .gql-docs .gql-nav-active { background: #2a2a2a; }\n[data-color-mode=\"dark\"] .gql-docs .gql-ex-select-label { background: #2a2a2a; }\n[data-color-mode=\"dark\"] .gql-docs .gql-sidebar-label { background: #161616; }\n[data-color-mode=\"dark\"] .gql-docs .gql-response-label { background: #161616; }\n\n/* ── Dark mode (README.io system + OS dark) ── */\n@media (prefers-color-scheme: dark) {\n  [data-color-mode=\"system\"] .gql-docs {\n    --gql-border: #333;\n    --gql-text: #e0e0e0;\n    --gql-text-muted: #999;\n    --gql-text-link: #58a6ff;\n    --gql-accent: #3fb980;\n    --gql-badge-required: #f97583;\n    --gql-badge-bg-required: #3d1a1e;\n  }\n  [data-color-mode=\"system\"] .gql-docs .gql-badge-non-null { background: #1a3a2a; }\n  [data-color-mode=\"system\"] .gql-docs .gql-callout { background: #1e1e1e; }\n  [data-color-mode=\"system\"] .gql-docs a.gql-nav-link:hover { background: #2a2a2a; }\n  [data-color-mode=\"system\"] .gql-docs .gql-nav-active { background: #2a2a2a; }\n  [data-color-mode=\"system\"] .gql-docs .gql-ex-select-label { background: #2a2a2a; }\n  [data-color-mode=\"system\"] .gql-docs .gql-sidebar-label { background: #161616; }\n  [data-color-mode=\"system\"] .gql-docs .gql-response-label { background: #161616; }\n}","stylesheet":"","favicon":["https://files.readme.io/ee510bc0f7c463612c51d58e576398fdb238ce0348a94eafa28cc22d29e08a0f-favicon.png","ee510bc0f7c463612c51d58e576398fdb238ce0348a94eafa28cc22d29e08a0f-favicon.png",82,82,"#23c469",null,"698cc7a7d6e7f8a533b52f17"],"logo_white_use":true,"logo_white":["https://files.readme.io/6569eeaca64d5940a1ed6368578c3ab19fbf6af30bce973b8eaa377ba656021d-short_black_bg.png","6569eeaca64d5940a1ed6368578c3ab19fbf6af30bce973b8eaa377ba656021d-short_black_bg.png",554,189,"#24cc6c",null,"6986216513536a76cb673f22"],"logo":["https://files.readme.io/6fdeecee3b160d06768dc696c4c0fe8ebd672b51f1e65e1e54e375a42893c599-short_white_bg.png","6fdeecee3b160d06768dc696c4c0fe8ebd672b51f1e65e1e54e375a42893c599-short_white_bg.png",554,189,"#24cc6c",null,"698cc7a33f7f42194dab77de"],"promos":[{"title":"Ordergroove Dev Docs","text":"Build your custom subscription experience that delights, growing recurring revenue to unprecedented heights.","extras":{"type":"none","buttonPrimary":"docs","buttonSecondary":"reference"},"_id":"5d63dabecc03470056f9c571"}],"body":{"style":"none"},"header":{"img_pos":"tl","img_size":"auto","img":[],"style":"solid","linkStyle":"tabs"},"typography":{"tk_body":"","tk_headline":"","tk_key":"","typekit":false,"body":"Open+Sans:400:sans-serif","headline":"Open+Sans:400:sans-serif","code":"","custom_heading":null,"custom_body":null,"custom_code":null,"spacing":null},"colors":{"body_highlight":"#219050","header_text":"","main_alt":"","main":"#493e90","highlight":"","custom_login_link_color":"","body_highlight_dark":"#219050"},"main_body":{"type":"links"},"splitReferenceDocs":false,"childrenAsPills":false,"hide_logo":false,"sticky":false,"landing":true,"overlay":"triangles","theme":"line","link_logo_to_url":false,"referenceLayout":"column","subheaderStyle":"links","rdmd":{"callouts":{"useIconFont":false},"theme":{"background":"","border":"","markdownEdge":"","markdownFont":"","markdownFontSize":"","markdownLineHeight":"","markdownRadius":"","markdownText":"","markdownTitle":"","markdownTitleFont":"","mdCodeBackground":"","mdCodeFont":"","mdCodeRadius":"","mdCodeTabs":"","mdCodeText":"","tableEdges":"","tableHead":"","tableHeadText":"","tableRow":"","tableStripe":"","tableText":"","text":"","title":""}},"showMetricsInReference":true,"referenceSimpleMode":true,"stylesheet_hub3":"","loginLogo":[],"logo_large":false,"colorScheme":"system","changelog":{"layoutExpanded":false,"showAuthor":true,"showExactDate":false},"allowApiExplorerJsonEditor":false,"ai_dropdown":"enabled","ai_options":{"chatgpt":"enabled","claude":"enabled","clipboard":"disabled","copilot":"enabled","view_as_markdown":"disabled","ask_ai":"enabled","mcp":{"command":"enabled","config":"enabled","cursor":"enabled","vscode":"enabled"}},"showPageIcons":true,"layout":{"full_width":false,"style":"compact"},"methodBadgeStyle":"modern","showMethodInSidebar":true,"showBreadcrumbs":true,"collapsibleCategories":true},"custom_domain":"developer.ordergroove.com","childrenProjects":[],"derivedPlan":"business2018","description":"","isExternalSnippetActive":false,"error404":"","experiments":[],"first_page":"reference","flags":{"translation":false,"directGoogleToStableVersion":false,"disableAnonForum":false,"newApiExplorer":true,"newEditor":true,"hideGoogleAnalytics":false,"cookieAuthentication":false,"allowXFrame":false,"speedyRender":false,"correctnewlines":false,"swagger":false,"oauth":false,"migrationSwaggerRun":false,"migrationRun":false,"hub2":true,"enterprise":false,"allow_hub2":false,"newSearch":true,"alwaysShowDocPublishStatus":false,"newMarkdownBetaProgram":true,"oldMarkdown":false,"rdmdCompatibilityMode":false,"tutorials":true,"staging":false,"allowApiExplorerJsonEditor":false,"useReactApp":true,"newHeader":false,"referenceRedesign":false,"auth0Oauth":false,"graphql":false,"singleProjectEnterprise":false,"dashReact":false,"allowReferenceUpgrade":true,"metricsV2":true,"newEditorDash":true,"enableRealtimeExperiences":false,"reviewWorkflow":true,"star":false,"allowDarkMode":false,"forceDarkMode":false,"useReactGLP":false,"disablePasswordlessLogin":false,"personalizedDocs":false,"myDevelopers":false,"superHub":true,"developerDashboard":false,"allowReusableOTPs":false,"dashHomeRefresh":false,"owlbotAi":false,"apiV2":false,"git":{"read":false,"write":false},"superHubBeta":false,"dashQuickstart":false,"disableAutoTranslate":false,"customBlocks":false,"devDashHub":false,"disableSAMLScoping":false,"allowUnsafeCustomHtmlSuggestionsFromNonAdmins":false,"apiAccessRevoked":false,"passwordlessLogin":"default","disableSignups":false,"billingRedesignEnabled":true,"developerPortal":false,"mdx":true,"superHubDevelopment":false,"annualBillingEnabled":true,"devDashBillingRedesignEnabled":false,"enableOidc":false,"customComponents":false,"disableDiscussionSpamRecaptchaBypass":false,"developerViewUsersData":false,"changelogRssAlwaysPublic":false,"bidiSync":true,"superHubMigrationSelfServeFlow":true,"apiDesigner":false,"hideEnforceSSO":false,"localLLM":false,"superHubManageVersions":false,"gitSidebar":false,"superHubGlobalCustomBlocks":false,"childManagedBidi":false,"superHubBranches":false,"externalSdkSnippets":false,"requiresJQuery":false,"migrationPreview":false,"superHubBranchReviews":false,"superHubMergePermissions":false,"superHubPreview":false,"aiDocsAudit":false,"aiPageLinting":false,"disableAiChat":false,"enableSuggestedEdits":false,"githubCloudSync":false,"superHubBranchMergeRules":false,"superHubBranchReviewActions":false,"bidiSyncGitlabSelfServe":true,"gitTranslations":false,"gitlabCloudSync":false,"bidiSyncBitbucketSelfServe":false,"superHubPlanManagement":true,"mdxSanitizeComments":false,"mdxish":false,"disableSuperframe":false,"hideAiFeatures":false,"gittoUseNewIndexer":true,"mdxishEditor":false,"prefetch":false,"aiWriter":false,"superHubBranchReviewDashboard":false,"bidiSyncUseOdbAlternates":true,"mcpMetrics":false,"newDereferencer":false,"newIframeStructure":false,"streamingSsr":false,"googleAuthEnabled":false,"superHubNotifications":false,"superHubTypography":false,"newExplorerReducer":false,"gittoUseExperimentalMDXCache":false,"gittoUseConnectionPooling":false,"askAiOverride":"","superHubSlack":false,"customDomainAdminBypass":false},"fullBaseUrl":"https://developer.ordergroove.com/","git":{"aiWriter":{"setup":{"error":{}}},"migration":{"createRepository":{"end":"2025-11-10T22:28:37.410Z","start":"2025-11-10T22:28:37.054Z","status":"successful"},"transformation":{"end":"2025-11-10T22:28:40.728Z","start":"2025-11-10T22:28:37.796Z","status":"successful"},"migratingPages":{"end":"2025-11-10T22:28:42.200Z","start":"2025-11-10T22:28:41.421Z","status":"successful"},"enableSuperhub":{"start":"2025-11-10T23:16:47.294Z","status":"successful","end":"2025-11-10T23:16:47.295Z"}},"sync":{"linked_internal_repository":{"name":"production-og-restrpc-ae46aa7e715d5b3d3680","full_name":"readme-internal-sync/production-og-restrpc-ae46aa7e715d5b3d3680","url":"https://github.com/readme-internal-sync/production-og-restrpc-ae46aa7e715d5b3d3680","id":"1167901385","privacy":{"visibility":"private","private":true}},"installationRequest":{},"connections":[],"providers":[]},"migrationType":"default","renamedSlugs":[]},"gitMigrationStatus":"migrated","glossaryTerms":[],"graphqlSchema":"","gracePeriod":{"enabled":false,"endsAt":null},"shouldGateDash":false,"healthCheck":{"provider":"","settings":{}},"hstsIncludeSubdomains":false,"i18n":{"defaultLanguage":"en","languages":["en"],"state":"enabled"},"intercom_secure_emailonly":false,"intercom":"","is_active":true,"internal":"","jwtExpirationTime":0,"landing_bottom":[{"type":"html","alignment":"left","html":"    \u003cheader class=\"header-area\">\n        \u003cdiv class=\"home-container\">\n            \u003cdiv class=\"header-wrapper\">\n                \u003cdiv class=\"header-left\">\n                    \u003cdiv class=\"header-menu\">\n                        \u003cul>\n                            \u003cli>\u003ca href=\"https://developer.ordergroove.com/\">Home\u003c/a>\u003c/li>\n                            \u003cli>\u003ca href=\"https://developer.ordergroove.com/docs\">Guides\u003c/a>\u003c/li>\n                            \u003cli>\u003ca href=\"https://developer.ordergroove.com/reference\">API Reference\u003c/a>\u003c/li>\n                        \u003c/ul>\n                    \u003c/div>\n                \u003c/div>\n                \u003cdiv class=\"header-right\">\n                    \u003cdiv class=\"logo\">\n                        \u003ca href=\"#\">\u003cimg src=\"https://files.readme.io/81f3860-logo.svg\" alt=\"\">\u003c/a>\n                    \u003c/div>\n                \u003c/div>\n            \u003c/div>\n        \u003c/div>\n    \u003c/header>\n\n\n\n\n    \u003c!-------------- Hero Area Start ------------->\n    \u003csection class=\"hero-area\">\n        \u003cdiv class=\"home-container\">\n          \u003cdiv class=\"hero-wrapper\">\n                \u003cdiv class=\"hero-left\">\n                    \u003cdiv class=\"hero__text\">\n                        \u003ch1>Start building with \u003cbr> the \u003cspan class=\"gradient__text\">Ordergroove API\u003c/span>\u003c/h1>\n                        \u003cp>Build your custom subscription experience that delights, growing recurring \n                            revenue to unprecedented heights.\u003c/p>\n                        \u003cdiv class=\"hero__btn\">\n                            \u003ca href=\"https://developer.ordergroove.com/docs/developer-fundamentals\" class=\"custom--btn\">Explore Guides\u003c/a>\n                        \u003c/div>\n                    \u003c/div>\n                \u003c/div>\n                \u003cdiv class=\"hero-right\">\n                    \u003cimg src=\"https://files.readme.io/79cf655-Visuals.svg\" alt=\"\">\n                \u003c/div>\n            \u003c/div>\n        \u003c/div>\n        \u003cimg src=\"https://files.readme.io/eea4d90-shp.svg\" class=\"hero-shp\" alt=\"\">\n        \u003cimg src=\"https://files.readme.io/1dc9cd9-hero-shp-2.png\" class=\"hero-shp-2\" alt=\"\">\n    \u003c/section>\n    \u003c!-------------- Hero Area End ------------->\n\n\n    \n    \u003c!-------------- Brand Area Start ------------->\n    \u003cdiv class=\"brand-area\">\n        \u003cdiv class=\"home-container\">\n            \u003cdiv class=\"brand-wrapper\">\n                \u003cdiv class=\"brand-item\">\n                    \u003cimg src=\"https://files.readme.io/4a0ee1f-cliff-logo_1.png\" alt=\"\">\n                \u003c/div>\n                \u003cdiv class=\"brand-item\">\n                    \u003cimg src=\"https://files.readme.io/eb0827b-daily-harvest-logo.png\" alt=\"\">\n                \u003c/div>\n                \u003cdiv class=\"brand-item\">\n                    \u003cimg src=\"https://files.readme.io/eb75e8b-dollar-shave-club-logo.png\" alt=\"\">\n                \u003c/div>\n              \u003c!--\n                \u003cdiv class=\"brand-item\">\n                    \u003cimg src=\"https://files.readme.io/d310e42-organifi.png\" alt=\"\">\n                \u003c/div>\n\t\t\t\t\t\t\t-->\n                \u003cdiv class=\"brand-item\">\n                    \u003cimg src=\"https://files.readme.io/eefd116-honest-2.png\" alt=\"\">\n                \u003c/div>\n                \u003cdiv class=\"brand-item\">\n                    \u003cimg src=\"https://files.readme.io/31753c3-LOreal_Logo.png\" alt=\"\">\n                \u003c/div>\n                \u003cdiv class=\"brand-item\">\n                    \u003cimg src=\"https://files.readme.io/7955915-G-Fuel-Logo.png\" alt=\"\">\n                \u003c/div>\n                \u003cdiv class=\"brand-item\">\n                    \u003cimg src=\"https://files.readme.io/1abd232-peets-logo.png\" alt=\"\">\n                \u003c/div>\n            \u003c/div>\n        \u003c/div>\n    \u003c/div>\n    \n    \u003c!-------------- Brand Area End ------------->\n\n   \n    \n    \u003c!-------------- Get Started Area Start ------------->\n    \u003cdiv class=\"get-started-area\">\n        \u003cdiv class=\"home-container\">\n            \u003cdiv class=\"area-title\">\n                \u003ch2>Get Started\u003c/h2>\n            \u003c/div>\n            \u003cdiv class=\"card-wrapper\">\n                \u003cdiv class=\"about-card\">\n                    \u003cdiv class=\"about-card-inner\">\n                        \u003cdiv class=\"icon-box\">\n                            \u003cimg src=\"https://files.readme.io/91d3c3e-star.svg\" alt=\"\">\n                            \u003cimg src=\"https://files.readme.io/df12502-Icon-bg.png\" class=\"icon-bg\" alt=\"\">\n                        \u003c/div>\n                        \u003ch2>Getting Started\u003c/h2>\n                        \u003cp>Get started with Ordergroove’s Data Model, Systems Landscape Map, and Authentication.\u003c/p>\n                        \u003cdiv class=\"card-btn\">\n                            \u003ca href=\"https://developer.ordergroove.com/docs/developer-fundamentals\">Start Here \u003cimg src=\"https://files.readme.io/86d0a34-ArrowRight.svg\" alt=\"\">\u003c/a>\n                        \u003c/div>\n                    \u003c/div>\n                \u003c/div>\n                \u003cdiv class=\"about-card\">\n                    \u003cdiv class=\"about-card-inner\">\n                        \u003cdiv class=\"icon-box\">\n                            \u003cimg src=\"https://files.readme.io/97cc15a-MagicWand.svg\" alt=\"\">\n                            \u003cimg src=\"https://files.readme.io/df12502-Icon-bg.png\" class=\"icon-bg\" alt=\"\">\n                        \u003c/div>\n                        \u003ch2>Guides\u003c/h2>\n                        \u003cp>Read detailed guides to help quickly launch custom subscription experiences. \u003c/p>\n                        \u003cdiv class=\"card-btn\">\n                            \u003ca href=\"https://developer.ordergroove.com/docs/developer-fundamentals\">Explore Guides \u003cimg src=\"https://files.readme.io/86d0a34-ArrowRight.svg\" alt=\"\">\u003c/a>\n                        \u003c/div>\n                    \u003c/div>\n                \u003c/div>\n                \u003cdiv class=\"about-card\">\n                    \u003cdiv class=\"about-card-inner\">\n                        \u003cdiv class=\"icon-box\">\n                            \u003cimg src=\"https://files.readme.io/8d75fa2-file-code.svg\" alt=\"\">\n                            \u003cimg src=\"https://files.readme.io/df12502-Icon-bg.png\" class=\"icon-bg\" alt=\"\">\n                        \u003c/div>\n                        \u003ch2>API Docs\u003c/h2>\n                        \u003cp>A technical guide to integrating with the Ordergroove Relationship Commerce Cloud outside our hosted experiences.\u003c/p>\n                        \u003cdiv class=\"card-btn\">\n                            \u003ca href=\"https://developer.ordergroove.com/reference/introduction\">Read API Docs \u003cimg src=\"https://files.readme.io/86d0a34-ArrowRight.svg\" alt=\"\">\u003c/a>\n                        \u003c/div>\n                    \u003c/div>\n                \u003c/div>\n            \u003c/div>\n        \u003c/div>\n    \u003c/div>\n    \n    \u003c!-------------- Get Started Area End ------------->\n\n\n    \u003c!-------------- Subscription Area Start ------------->\n    \u003cdiv class=\"subscription-area\">\n        \u003cdiv class=\"home-container\">\n            \u003cdiv class=\"subscription-wrapper\">\n                \u003cdiv class=\"subscription-content\">\n                    \u003ch5>Subscription Partners\u003c/h5>\n                    \u003ch2>Memorable subscription experiences, \u003cbr> built better \u003cspan class=\"gradient-text-two\">together\u003c/span> \u003c/h2>\n                    \u003cp>Ordergroove partners with leading eCommerce agencies to create frictionless\n                        subscription experiences that delight shoppers and drive revenue.\u003c/p>\n                    \u003cdiv class=\"partner-btn\">\n                        \u003ca href=\"https://www.ordergroove.com/partners/\" class=\"custom--btn\">Partner with us\u003c/a>\n                    \u003c/div>\n                \u003c/div>\n                \u003cdiv class=\"subscription-thumb\">\n                    \u003cimg src=\"https://files.readme.io/470739f-img.png\" alt=\"\">\n                \u003c/div>\n            \u003c/div>\n        \u003c/div>\n    \u003c/div>\n    \u003c!-------------- Subscription Area End ------------->\n\n\n\n\n    \u003c!-------------- Footer Area Start ------------->\n  \u003csection class=\"home-footer\">\n        \u003cdiv class=\"home-container\">\n            \u003cdiv class=\"footer-wrapper\">\n                \u003cdiv class=\"footer-left\">\n                    \u003cdiv class=\"footer-logo\">\n                        \u003ca href=\"#\">\u003cimg src=\"https://files.readme.io/81f3860-logo.svg\" alt=\"\">\u003c/a>\n                    \u003c/div>\n                    \u003cdiv class=\"footer-left-content\">\n                        \u003cp>Putting relationships at the center of commerce to help all merchants thrive.\u003c/p>\n                        \u003cp>382 NE 191st Street, Suite 56661 \u003cbr>\n                            Miami, FL 33179\u003c/p>\n                    \u003c/div>\n                    \n                    \u003c!-------- FORM FOR EMAIL\n                    \u003cdiv class=\"subscription-form\">\n                        \u003clabel for=\"\">GET UPDATES\u003c/label>\n                        \u003cdiv class=\"subscription-box\">\n                            \u003cinput type=\"text\" placeholder=\"your email\">\n                            \u003cbutton>\u003cimg src=\"https://files.readme.io/86d0a34-ArrowRight.svg\" alt=\"\">\u003c/button>\n                        \u003c/div>\n                    \u003c/div>\n                   FORM FOR EMAIL ------------->\n                \n                \u003c/div>\n                \u003cdiv class=\"footer-right\">\n                    \u003cdiv class=\"footer-widget\">\n                        \u003ch3>Product\u003c/h3>\n                        \u003cdiv class=\"footer-links\">\n                            \u003cul>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/product/why-ordergroove/\">Why Ordergroove\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/product/subscription-incentives/\">Incentives\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/product/subscriber-experience/\">Subscriber Experience\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/product/subscription-performance/\">Performance\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/integrations/\">Integrations\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/product/subscription-first-experiences/\">Subscription-first Experiences\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/product/support/\">Customer Success &amp; Support\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/demo/\">Get Started\u003c/a>\u003c/li>\n                            \u003c/ul>\n                        \u003c/div>\n                    \u003c/div>\n                    \u003cdiv class=\"footer-widget\">\n                        \u003ch3>Solutions\u003c/h3>\n                        \u003cdiv class=\"footer-links\">\n                            \u003cdiv class=\"subtitle\">\n                                \u003ch4>BY STRATEGY\u003c/h4>\n                            \u003c/div>\n                            \u003cul>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/solutions/launch-subscriptions/\">Launch Subscriptions\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/solutions/migrate/\">Migrate to Ordergroove\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/solutions/scale-subscriptions/\">Scale Subscriptions\u003c/a>\u003c/li>\n                            \u003c/ul>\n                        \u003c/div>\n                        \u003cdiv class=\"footer-links\">\n                            \u003cdiv class=\"subtitle\">\n                                \u003ch4>BY PLATFORM\u003c/h4>\n                            \u003c/div>\n                            \u003cul>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/integrations/shopify-plus/\">Shopify Plus\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/integrations/commercetools/\">Commercetools\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/integrations/shopify/\">Shopify\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/integrations/salesforce/\">Salesforce\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/integrations/magento/\">Magento\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/integrations/bigcommerce/\">BigCommerce\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/integrations/adobe-commerce/\">Adobe Commerce\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/integrations/custom/\">Custom Cart\u003c/a>\u003c/li>\n                            \u003c/ul>\n                        \u003c/div>\n                    \u003c/div>\n                    \u003cdiv class=\"footer-widget\">\n                        \u003ch3>Company\u003c/h3>\n                        \u003cdiv class=\"footer-links\">\n                            \u003cul>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/contact/\">Contact\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/careers/\">Careers\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/company/leadership/\">Leadership\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/press/\">Press\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/partners/\">Partners\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/security/\">Security\u003c/a>\u003c/li>\n                            \u003c/ul>\n                        \u003c/div>\n                        \u003cdiv class=\"footer-links\">\n                            \u003ch3>Resources\u003c/h3>\n                            \u003cul>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/blog/\">Blog\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/case-studies/\">Case Studies\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/webinars/\">Webinars\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/resources/\">Guides &amp; Reports\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://ordergroove.zendesk.com/hc/en-us\">Knowledge Center\u003c/a>\u003c/li>\n                            \u003c/ul>\n                        \u003c/div>\n                    \u003c/div>\n                \u003c/div>\n            \u003c/div>\n            \u003cdiv class=\"row\">\n                \u003cdiv class=\"col-lg-12\">\n                    \u003cdiv class=\"footer-bottom-wrapper\">\n                        \u003cdiv class=\"copyright-text\">\n                            \u003cp>© 2024 Ordergroove. All rights reserved.\u003c/p>\n                        \u003c/div>\n                        \u003cdiv class=\"social-links\">\n                            \u003cul class=\"social flex a-c\">\n                              \u003cli>\n                                \u003ca href=\"https://www.facebook.com/OrderGroove/\" title=\"Link to Ordergroove's Facebook\" target=\"_blank\" aria-label=\"Link to Ordergroove's Facebook\">\u003csvg width=\"8\" height=\"16\" viewBox=\"0 0 8 16\" fill=\"none\" xmlns=\"http://www.w3.org/2000/svg\">\u003cpath d=\"M5.19532 15.8638H2.38282V8.36377H0.507818V5.78564H2.38282V4.28565C2.38282 2.17627 2.94532 0.910647 5.42969 0.910647H7.49219V3.48877H6.17968C5.19531 3.48877 5.14844 3.86377 5.14844 4.52002V5.83252H7.49219L7.21094 8.41065H5.14844L5.19532 15.8638Z\" fill=\"#D8D7DF\">\u003c/path>\u003c/svg>\u003c/a>\n                              \u003c/li>\n                              \u003cli>\n                                \u003ca href=\"https://www.linkedin.com/company/ordergroove-inc.\" title=\"Link to Ordergroove's Linkedin\" target=\"_blank\" aria-label=\"Link to Ordergroove's Linkedin\">\u003c!--?xml version=\"1.0\" encoding=\"utf-8\"?-->\u003csvg width=\"14\" height=\"14\" viewBox=\"0 0 14 14\" fill=\"none\" xmlns=\"http://www.w3.org/2000/svg\"> \u003cpath d=\"M3.38031 2.22818C3.38031 3.01868 2.79784 3.64274 1.84093 3.64274C0.925614 3.64274 0.34314 3.01868 0.34314 2.22818C0.34314 1.43769 0.925614 0.813599 1.84093 0.813599C2.79784 0.813599 3.33871 1.43769 3.38031 2.22818ZM0.426349 13.9608V4.80768H3.2555V13.9608H0.426349ZM5.00291 7.72004C5.00291 6.5967 4.96131 5.63978 4.9197 4.80768H7.37441L7.49922 6.09745H7.54083C7.91527 5.51498 8.83058 4.59965 10.37 4.59965C12.2422 4.59965 13.6568 5.84781 13.6568 8.55214V13.9608H10.8276V8.885C10.8276 7.72006 10.4116 6.88793 9.37145 6.88793C8.58095 6.88793 8.12329 7.42882 7.91527 7.96968C7.83206 8.1361 7.83206 8.42734 7.83206 8.67697V13.9608H5.00291V7.72004Z\" fill=\"#D8D7DF\">\u003c/path> \u003c/svg> \u003c/a>\n                              \u003c/li>\n                              \u003cli>\n                                \u003ca href=\"https://twitter.com/ordergroove\" title=\"Link to Ordergroove's Twitter\" target=\"_blank\" aria-label=\"Link to Ordergroove's Twitter\">\u003c!--?xml version=\"1.0\" encoding=\"utf-8\"?-->\u003csvg width=\"16\" height=\"13\" viewBox=\"0 0 16 13\" fill=\"none\" xmlns=\"http://www.w3.org/2000/svg\"> \u003cpath d=\"M15.7576 1.53403C15.1776 1.77791 14.5976 1.97301 13.9209 2.02179C14.5976 1.63158 15.0809 0.997491 15.3226 0.265852C14.6943 0.65606 14.0176 0.899942 13.2926 1.04627C12.7126 0.412183 11.8909 0.0219727 10.9725 0.0219727C9.23249 0.0219727 7.78246 1.43648 7.78246 3.24119C7.78246 3.48507 7.83079 3.72895 7.87913 3.97283C5.22074 3.8265 2.90069 2.55832 1.354 0.607282C1.06399 1.09504 0.91899 1.63158 0.91899 2.21689C0.91899 3.33874 1.499 4.31425 2.32068 4.89956C1.789 4.89956 1.30566 4.75324 0.870653 4.50936V4.55813C0.870653 6.11896 1.98234 7.38713 3.43237 7.67979C3.14237 7.72857 2.9007 7.77734 2.61069 7.77734C2.41735 7.77734 2.22402 7.77735 2.03068 7.72857C2.41736 8.99674 3.62571 9.92348 4.97907 9.97226C3.91571 10.8502 2.51402 11.338 1.01566 11.338C0.773986 11.338 0.483984 11.338 0.242313 11.2892C1.64401 12.216 3.3357 12.7525 5.12407 12.7525C10.9725 12.7525 14.1626 7.87489 14.1626 3.63139C14.1626 3.48506 14.1626 3.33874 14.1626 3.24119C14.7909 2.70465 15.3709 2.16812 15.7576 1.53403Z\" fill=\"#D8D7DF\">\u003c/path> \u003c/svg> \u003c/a>\n                              \u003c/li>\n                              \u003cli>\n                                \u003ca href=\"https://apps.shopify.com/ordergroove\" title=\"Link to Ordergroove's Shopify App\" target=\"_blank\" aria-label=\"Link to Ordergroove's Shopify App\">\u003csvg width=\"15\" height=\"17\" viewBox=\"0 0 15 17\" fill=\"none\" xmlns=\"http://www.w3.org/2000/svg\"> \u003cpath fill-rule=\"evenodd\" clip-rule=\"evenodd\" d=\"M12.9888 3.13432C13.051 3.1395 13.126 3.18712 13.1378 3.27296C13.1496 3.3588 15 15.8699 15 15.8699L10.4645 16.9974L0 15.1875C0 15.1875 1.24871 5.53174 1.29492 5.19177C1.35717 4.74188 1.37225 4.72726 1.84948 4.57731C1.85963 4.57403 2.18152 4.47434 2.6939 4.31567C2.9194 4.24584 3.18178 4.16459 3.47073 4.0751C3.57163 3.3522 3.92767 2.41849 4.39547 1.6753C5.06038 0.618994 5.88042 0.0243505 6.70377 0.000772282C7.13055 -0.01196 7.48656 0.132811 7.76432 0.429895C7.78413 0.45159 7.80299 0.473751 7.82186 0.496386C7.82659 0.495984 7.83132 0.495576 7.83604 0.495168C7.87554 0.491758 7.91475 0.488372 7.95436 0.488372H7.95671C8.59428 0.489312 9.12196 0.852889 9.48222 1.54043C9.59398 1.75358 9.67228 1.96579 9.72557 2.13838C9.80673 2.11325 9.87949 2.09072 9.94287 2.0711C10.1281 2.01377 10.2332 1.98123 10.2339 1.98087C10.3098 1.95824 10.5051 1.92806 10.605 2.02803C10.705 2.128 11.717 3.11075 11.717 3.11075C11.717 3.11075 12.927 3.12913 12.9888 3.13432ZM8.3896 2.55194L9.20165 2.30059C9.07196 1.87902 8.76451 1.17214 8.13968 1.05378C8.33396 1.55505 8.38348 2.13508 8.3896 2.55194ZM6.09498 3.26259L7.84212 2.7217C7.84778 2.26664 7.79826 1.59372 7.5705 1.11838C7.32811 1.21835 7.12347 1.3933 6.97729 1.55033C6.584 1.97239 6.26379 2.61607 6.09498 3.26259ZM7.21542 0.678411C7.0763 0.586928 6.9136 0.544486 6.72026 0.54873C5.44939 0.585512 4.34077 2.57033 4.05733 3.89308C4.31745 3.81275 4.59056 3.72814 4.87123 3.64118C5.07496 3.57806 5.28267 3.51371 5.49231 3.44886C5.65217 2.60853 6.053 1.73755 6.57598 1.17638C6.7778 0.959936 6.99284 0.793945 7.21542 0.678411ZM7.42189 7.43734L7.94861 5.46669C7.94861 5.46669 7.4945 5.24034 6.60701 5.2974C4.30344 5.44264 3.25937 7.05351 3.35983 8.64314C3.42684 9.70435 4.05206 10.148 4.60006 10.5368C5.02756 10.8402 5.40806 11.1102 5.43988 11.614C5.45733 11.8918 5.28475 12.2846 4.80186 12.3152C4.06244 12.3619 3.13866 11.6649 3.13866 11.6649L2.78545 13.1673C2.78545 13.1673 3.70312 14.1505 5.37011 14.0454C6.75885 13.9577 7.72274 12.8467 7.62042 11.2226C7.54169 9.97393 6.66237 9.41011 5.96738 8.96448C5.51331 8.67333 5.13793 8.43263 5.11594 8.08435C5.10554 7.92259 5.11639 7.27844 6.13782 7.21382C6.83432 7.16997 7.42189 7.43734 7.42189 7.43734Z\" fill=\"#D8D7DF\">\u003c/path> \u003c/svg> \u003c/a>\n                              \u003c/li>\n                            \u003c/ul>\n                \n                        \u003c/div>\n                    \u003c/div>\n                \u003c/div>\n            \u003c/div>\n        \u003c/div>\n    \u003c/section>\n    \u003c!-------------- Footer Area End ------------->"}],"mdxMigrationStatus":"rdmd","metrics":{"thumbsEnabled":true,"enabled":false,"monthlyLimit":0,"planLimit":1000000,"realtime":{"dashEnabled":false,"hubEnabled":false},"monthlyPurchaseLimit":0,"meteredBilling":{}},"modules":{"logs":false,"suggested_edits":false,"discuss":false,"changelog":false,"reference":true,"examples":true,"docs":true,"landing":false,"custompages":false,"tutorials":false,"graphql":false},"name":"Ordergroove API Reference","nav_names":{"discuss":"","changelog":"","reference":"","docs":"","tutorials":"","recipes":""},"oauth_url":"","onboardingCompleted":{"documentation":true,"appearance":true,"jwt":true,"api":true,"logs":false,"domain":false,"metricsSDK":false,"aiReady":false},"owlbot":{"enabled":true,"isPaying":true,"customization":{"answerLength":"long","defaultAnswer":"","forbiddenWords":"","tone":"neutral","customTone":"","showAiDisclaimer":false},"copilot":{"enabled":false,"hasBeenUsed":false,"installedCustomPage":""},"exampleQuestions":{"question1":"","question2":"","question3":""},"knowledge":"","modelList":[],"newExperience":true,"lastIndexed":"2026-05-07T02:03:48.171Z","knowledgeSegregation":false,"trial":{"isPaying":false},"v2":false,"llmOptions":{"model":{}}},"owner":{"id":"62ab34d650f46b00211ebe47","email":null,"name":null},"plan":"business2018","planOverride":"business2018","planSchedule":{"stripeScheduleId":null,"changeDate":null,"nextPlan":null},"planStatus":"active","planTrial":"business2018","readmeScore":{"components":{"newDesign":{"enabled":true,"points":25},"reference":{"enabled":true,"points":50},"tryItNow":{"enabled":true,"points":35},"syncingOAS":{"enabled":false,"points":10},"customLogin":{"enabled":true,"points":25},"metrics":{"enabled":false,"points":40},"recipes":{"enabled":false,"points":15},"pageVoting":{"enabled":true,"points":1},"suggestedEdits":{"enabled":true,"points":10},"support":{"enabled":true,"points":5},"htmlLanding":{"enabled":true,"points":5},"guides":{"enabled":true,"points":10},"changelog":{"enabled":false,"points":5},"glossary":{"enabled":false,"points":1},"variables":{"enabled":false,"points":1},"integrations":{"enabled":true,"points":2}},"percentScore":75,"totalScore":168},"reCaptchaSiteKey":"","reference":{"alwaysUseDefaults":true,"autoFillRequestExample":false,"defaultExpandResponseExample":false,"defaultExpandResponseSchema":false,"enableOAuthFlows":false},"seo":{"overwrite_title_tag":false},"ssl":{"minTLS":"1.0"},"stable":{"_id":"6541205377b2190a15527a9f","version":"2.10.0","version_clean":"2.10.0","codename":"","is_stable":true,"is_beta":false,"is_hidden":false,"is_deprecated":false,"categories":["5d63dabecc03470056f9c575","6541205377b2190a15527a07","5d63de895179b9004cf25083","6541205377b2190a15527a08","6541205377b2190a15527a09","6541205377b2190a15527a0a","6541205377b2190a15527a0b","6541205377b2190a15527a0c","6541205377b2190a15527a0d","6541205377b2190a15527a0e","6541205377b2190a15527a0f","6541205377b2190a15527a10","6541205377b2190a15527a11","6541205377b2190a15527a12","6541205377b2190a15527a13","5d7900c7d202e7003baec4b9","5d790119b3a9600024df0154","5da5e2cbc9b875004c79804f","5dc976352c62b30047202bcf","5dcc503bd6d997002e28a2fc","5ddc07a83604cd004a95db37","6541205377b2190a15527a15","5f74b18f26833a004fb62c9c","6541205377b2190a15527a16","600895cdd4fedc001ea6e230","600896a80742ab004868158f","6011a019ec3e230011f40f46","6011a18d86276d00127aa69c","6011a27603c6b10056bd6681","6011a542e07e9f003a1938ca","6011a6e90ac1c2004008f867","6011b6335d8879006ea33d33","6011b6f8702e6e00397c2568","6011b71d01538900728b57fa","6011b885ec85810065f1e0db","6011b9865b40f800335ea54c","6011bc459f9939002791ee38","6011bf675bb4f3002c1b1225","6011c1876febb20073b944f7","6011c1d27a056e01646e546a","6011c2b143ac3f003dff1e03","6011c848c98d060607c4958a","6011cf50bda72704c87038b3","6011cf59c412f8059846be53","6011cf6928eb3005a245c925","6011cf7ba648b204adb57aec","6011cfe041e5e005bf97309e","6011d028cd7e160026ae3d20","6011d2314f5963062adcba1a","6011d2ff3e486f0560984f59","6011d3c85f5f920036d01397","6012ece434e66f0046a16db6","6066b7c7d1064a00234c9508","6376b49b2ac94400030a7a28","646791b0a28e6c06f696fb77","6541205377b2190a15527a17","6541205377b2190a15527a18","6541205377b2190a15527a19","6541205377b2190a15527a1a","6509e98612ea3a000bb40411","6509ebf786c93f004507384d","6541205377b2190a15527a1b","6541205377b2190a15527a1c","6541205377b2190a15527a1d","6541205377b2190a15527a1e","653c13fe786fd60065f449ee","6541205377b2190a15527aa1","656f601bf9bd75003e2078b0","6570958208334100eec412b0","65b57fe5064162003155a1a4","65bbca3b7adc2c00383c87d1","65c6898486578e000eecdfd1","65ccf81b9aba0000299887cb","6619430f18098e005e7a5cf5","66196f81a0dfe200360d753c","662aa1074daa7c005c035876","66c6362a025d0c005a28909d","66ec1e913784117131dfdd3e","66edc55f2fc54a005e4a0540","6709930cf504a7006e20c2d6","670fc31b87db74003dbf9546","6711742526344c004d5d6c2b","67117484fd7d140011c3a8d7","671175cdfd7d140011c3a8ec","67117e82522a4b001e7e1678","67192d04d3bf5a006919e7c8","683a02bfab1a560061005eda","683a20b779a72f001e39c578","683a22489d0bb90056ff0cc4","683f22ca4e01cd0044152160","685c4ee41b672d0060f4b4f3","68fbd52691cffd91ac050a3d","68ff7a6c68ccccb9a245b351"],"project":"5d63dabecc03470056f9c570","createdAt":"2023-10-31T15:42:10.972Z","releaseDate":"2019-08-26T13:12:30.117Z","__v":4,"forked_from":"653c13fe786fd60065f449ec","updatedAt":"2026-03-30T17:30:32.383Z","apiRegistries":[{"filename":"ordergroove-restrpc.json","uuid":"jqx21mvmkbf1d9c"},{"filename":"ordergroove-payment-api.json","uuid":"x4ryrmk8xnqpr"},{"filename":"ordergroove-webhooks-api.json","uuid":"x4r1mmmkb8lkth"},{"filename":"ordergroove-cart-management-api.json","uuid":"3s622tlona0k2o"},{"filename":"ordergroove-entitlements-service-api.json","uuid":"37hxpmndgrqr1"},{"filename":"payment_attempt_data_api.yaml","uuid":"c3qf1ommwbmg3y"}],"pdfStatus":"complete","source":"readme"},"subdomain":"og-restrpc","subpath":"","superHubWaitlist":false,"topnav":{"edited":true,"right":[],"left":[],"bottom":[{"type":"url","text":"Knowledge Center","url":"https://help.ordergroove.com/hc/en-us"},{"type":"url","text":"Academy","url":"https://academy.ordergroove.com/hc/en-us"}]},"trial":{"trialDeadlineEnabled":true,"trialEndsAt":"2025-12-01T17:28:50.503Z"},"translate":{"languages":[],"project_name":"","org_name":"","key_public":"","show_widget":false,"provider":"transifex"},"url":"","versions":[{"_id":"601e141052436600765a6d52","version":"2.6.0","version_clean":"2.6.0","codename":"Subscription Management Interface","is_stable":false,"is_beta":true,"is_hidden":false,"is_deprecated":false,"categories":["5d63dabecc03470056f9c575","601e141052436600765a6cba","5d63de895179b9004cf25083","601e141052436600765a6cbb","601e141052436600765a6cbc","601e141052436600765a6cbd","601e141052436600765a6cbe","601e141052436600765a6cbf","601e141052436600765a6cc0","601e141052436600765a6cc1","601e141052436600765a6cc2","601e141052436600765a6cc3","601e141052436600765a6cc4","601e141052436600765a6cc5","601e141052436600765a6cc6","5d7900c7d202e7003baec4b9","5d790119b3a9600024df0154","5da5e2cbc9b875004c79804f","601e141052436600765a6cc7","5dcc503bd6d997002e28a2fc","5ddc07a83604cd004a95db37","601e141052436600765a6ccf","5f74b18f26833a004fb62c9c","601e141052436600765a6cd0","600895cdd4fedc001ea6e230","600896a80742ab004868158f","6011a019ec3e230011f40f46","6011a18d86276d00127aa69c","6011a27603c6b10056bd6681","6011a542e07e9f003a1938ca","6011a6e90ac1c2004008f867","6011b6335d8879006ea33d33","6011b6f8702e6e00397c2568","6011b71d01538900728b57fa","6011b885ec85810065f1e0db","6011b9865b40f800335ea54c","6011bc459f9939002791ee38","6011bf675bb4f3002c1b1225","6011c1876febb20073b944f7","6011c1d27a056e01646e546a","6011c2b143ac3f003dff1e03","6011c848c98d060607c4958a","6011cf50bda72704c87038b3","6011cf59c412f8059846be53","6011cf6928eb3005a245c925","6011cf7ba648b204adb57aec","6011cfe041e5e005bf97309e","6011d028cd7e160026ae3d20","6011d2314f5963062adcba1a","6011d2ff3e486f0560984f59","601e141052436600765a6cd1","601e141052436600765a6cd2","60552e0ac164ed00660c817a","6376b49b2ac94400030a7a30"],"project":"5d63dabecc03470056f9c570","createdAt":"2019-08-26T13:12:30.117Z","releaseDate":"2019-08-26T13:12:30.117Z","__v":3,"forked_from":"5d63dabecc03470056f9c574","apiRegistries":[{"filename":"ordergroove-restrpc.json","uuid":"1mld74kq6wfgpr"},{"filename":"ordergroove-cart-management-api.json","uuid":"1mld74kq6wfgo8"},{"filename":"ordergroove-payment-api.json","uuid":"1mld74kq6wfgoz"},{"filename":"ordergroove-webhooks-api.json","uuid":"1mld74kq6wfgn6"},{"filename":"anticipate-ai.json","uuid":"1mld74kq6wfglm"},{"filename":"page.json","uuid":"1mld74kq6wfgll"},{"filename":"page-1.json","uuid":"1mld74kq6wfglk"},{"filename":"page-2.json","uuid":"1mld74kq6wfgln"}],"pdfStatus":"","source":"readme","updatedAt":"2025-11-10T22:28:35.927Z"},{"_id":"646791b0a28e6c06f696fb75","version":"2.8.0","version_clean":"2.8.0","codename":"","is_stable":false,"is_beta":false,"is_hidden":false,"is_deprecated":false,"categories":["5d63dabecc03470056f9c575","646791b0a28e6c06f696fb07","5d63de895179b9004cf25083","646791b0a28e6c06f696fb08","646791b0a28e6c06f696fb09","646791b0a28e6c06f696fb0a","646791b0a28e6c06f696fb0b","646791b0a28e6c06f696fb0c","646791b0a28e6c06f696fb0d","646791b0a28e6c06f696fb0e","646791b0a28e6c06f696fb0f","646791b0a28e6c06f696fb10","646791b0a28e6c06f696fb11","646791b0a28e6c06f696fb12","646791b0a28e6c06f696fb13","5d7900c7d202e7003baec4b9","5d790119b3a9600024df0154","5da5e2cbc9b875004c79804f","5dc976352c62b30047202bcf","5dcc503bd6d997002e28a2fc","5ddc07a83604cd004a95db37","646791b0a28e6c06f696fb15","5f74b18f26833a004fb62c9c","646791b0a28e6c06f696fb16","600895cdd4fedc001ea6e230","600896a80742ab004868158f","6011a019ec3e230011f40f46","6011a18d86276d00127aa69c","6011a27603c6b10056bd6681","6011a542e07e9f003a1938ca","6011a6e90ac1c2004008f867","6011b6335d8879006ea33d33","6011b6f8702e6e00397c2568","6011b71d01538900728b57fa","6011b885ec85810065f1e0db","6011b9865b40f800335ea54c","6011bc459f9939002791ee38","6011bf675bb4f3002c1b1225","6011c1876febb20073b944f7","6011c1d27a056e01646e546a","6011c2b143ac3f003dff1e03","6011c848c98d060607c4958a","6011cf50bda72704c87038b3","6011cf59c412f8059846be53","6011cf6928eb3005a245c925","6011cf7ba648b204adb57aec","6011cfe041e5e005bf97309e","6011d028cd7e160026ae3d20","6011d2314f5963062adcba1a","6011d2ff3e486f0560984f59","6011d3c85f5f920036d01397","6012ece434e66f0046a16db6","6066b7c7d1064a00234c9508","6376b49b2ac94400030a7a28","646791b0a28e6c06f696fb77","64e7acb03029a8000bc13b1c","65022637d507bc00195bc26c","6509e96b7e67aa001335bb89","6509e9787e0cb7004319be60","6509e98612ea3a000bb40411","6509ebf786c93f004507384d","6509eddef3c16f00499b07ee","6512dc68da901900363808a4","65142916a9e4f00063c0bf13","65148c9726e9e9003d95c0c3"],"project":"5d63dabecc03470056f9c570","createdAt":"2019-08-26T13:12:30.117Z","releaseDate":"2019-08-26T13:12:30.117Z","__v":1,"forked_from":"5d63dabecc03470056f9c574","updatedAt":"2025-11-10T22:28:35.929Z","apiRegistries":[{"filename":"ordergroove-payment-api.json","uuid":"3z6gfjol6kxwfff"},{"filename":"ordergroove-cart-management-api.json","uuid":"1mld74kq6vzi1q"},{"filename":"ordergroove-webhooks-api.json","uuid":"1lomb22kwcqa7s1"},{"filename":"page.json","uuid":"1mld74kq6weqv5"},{"filename":"ordergroove-restrpc.json","uuid":"p570fstln9cy6cw"},{"filename":"page-1.json","uuid":"1mld74kq6wf16p"},{"filename":"page-2.json","uuid":"1mld74kq6wf164"},{"filename":"anticipate-ai.json","uuid":"3sfkwxycgbj"}],"pdfStatus":"","source":"readme"},{"_id":"653c13fe786fd60065f449ec","version":"2.9.0","version_clean":"2.9.0","codename":"","is_stable":false,"is_beta":false,"is_hidden":false,"is_deprecated":false,"categories":["5d63dabecc03470056f9c575","653c13fe786fd60065f44960","5d63de895179b9004cf25083","653c13fe786fd60065f44961","653c13fe786fd60065f44962","653c13fe786fd60065f44963","653c13fe786fd60065f44964","653c13fe786fd60065f44965","653c13fe786fd60065f44966","653c13fe786fd60065f44967","653c13fe786fd60065f44968","653c13fe786fd60065f44969","653c13fe786fd60065f4496a","653c13fe786fd60065f4496b","653c13fe786fd60065f4496c","5d7900c7d202e7003baec4b9","5d790119b3a9600024df0154","5da5e2cbc9b875004c79804f","5dc976352c62b30047202bcf","5dcc503bd6d997002e28a2fc","5ddc07a83604cd004a95db37","653c13fe786fd60065f4496e","5f74b18f26833a004fb62c9c","653c13fe786fd60065f4496f","600895cdd4fedc001ea6e230","600896a80742ab004868158f","6011a019ec3e230011f40f46","6011a18d86276d00127aa69c","6011a27603c6b10056bd6681","6011a542e07e9f003a1938ca","6011a6e90ac1c2004008f867","6011b6335d8879006ea33d33","6011b6f8702e6e00397c2568","6011b71d01538900728b57fa","6011b885ec85810065f1e0db","6011b9865b40f800335ea54c","6011bc459f9939002791ee38","6011bf675bb4f3002c1b1225","6011c1876febb20073b944f7","6011c1d27a056e01646e546a","6011c2b143ac3f003dff1e03","6011c848c98d060607c4958a","6011cf50bda72704c87038b3","6011cf59c412f8059846be53","6011cf6928eb3005a245c925","6011cf7ba648b204adb57aec","6011cfe041e5e005bf97309e","6011d028cd7e160026ae3d20","6011d2314f5963062adcba1a","6011d2ff3e486f0560984f59","6011d3c85f5f920036d01397","6012ece434e66f0046a16db6","6066b7c7d1064a00234c9508","6376b49b2ac94400030a7a28","646791b0a28e6c06f696fb77","653c13fe786fd60065f44970","653c13fe786fd60065f44971","653c13fe786fd60065f44972","653c13fe786fd60065f44973","6509e98612ea3a000bb40411","6509ebf786c93f004507384d","653c13fe786fd60065f44974","653c13fe786fd60065f44975","653c13fe786fd60065f44976","653c13fe786fd60065f44977","653c13fe786fd60065f449ee"],"project":"5d63dabecc03470056f9c570","createdAt":"2023-10-27T19:48:14.642Z","releaseDate":"2019-08-26T13:12:30.117Z","__v":2,"forked_from":"646791b0a28e6c06f696fb75","updatedAt":"2025-11-10T22:28:35.933Z","apiRegistries":[{"filename":"ordergroove-payment-api.json","uuid":"3z6gfjol6kxwfff"},{"filename":"page.json","uuid":"1mld74kq6weqv5"},{"filename":"ordergroove-cart-management-api.json","uuid":"1mld74kq6vzi1q"},{"filename":"anticipate-ai.json","uuid":"3sfkwxycgbj"},{"filename":"ordergroove-restrpc.json","uuid":"3d9o0f2hlodbsajh"},{"filename":"ordergroove-webhooks-api.json","uuid":"1lomb22kwcqa7s1"},{"filename":"page-1.json","uuid":"1mld74kq6wf164"},{"filename":"page-2.json","uuid":"1mld74kq6wf16p"}],"pdfStatus":"","source":"readme"},{"_id":"6541205377b2190a15527a9f","version":"2.10.0","version_clean":"2.10.0","codename":"","is_stable":true,"is_beta":false,"is_hidden":false,"is_deprecated":false,"categories":["5d63dabecc03470056f9c575","6541205377b2190a15527a07","5d63de895179b9004cf25083","6541205377b2190a15527a08","6541205377b2190a15527a09","6541205377b2190a15527a0a","6541205377b2190a15527a0b","6541205377b2190a15527a0c","6541205377b2190a15527a0d","6541205377b2190a15527a0e","6541205377b2190a15527a0f","6541205377b2190a15527a10","6541205377b2190a15527a11","6541205377b2190a15527a12","6541205377b2190a15527a13","5d7900c7d202e7003baec4b9","5d790119b3a9600024df0154","5da5e2cbc9b875004c79804f","5dc976352c62b30047202bcf","5dcc503bd6d997002e28a2fc","5ddc07a83604cd004a95db37","6541205377b2190a15527a15","5f74b18f26833a004fb62c9c","6541205377b2190a15527a16","600895cdd4fedc001ea6e230","600896a80742ab004868158f","6011a019ec3e230011f40f46","6011a18d86276d00127aa69c","6011a27603c6b10056bd6681","6011a542e07e9f003a1938ca","6011a6e90ac1c2004008f867","6011b6335d8879006ea33d33","6011b6f8702e6e00397c2568","6011b71d01538900728b57fa","6011b885ec85810065f1e0db","6011b9865b40f800335ea54c","6011bc459f9939002791ee38","6011bf675bb4f3002c1b1225","6011c1876febb20073b944f7","6011c1d27a056e01646e546a","6011c2b143ac3f003dff1e03","6011c848c98d060607c4958a","6011cf50bda72704c87038b3","6011cf59c412f8059846be53","6011cf6928eb3005a245c925","6011cf7ba648b204adb57aec","6011cfe041e5e005bf97309e","6011d028cd7e160026ae3d20","6011d2314f5963062adcba1a","6011d2ff3e486f0560984f59","6011d3c85f5f920036d01397","6012ece434e66f0046a16db6","6066b7c7d1064a00234c9508","6376b49b2ac94400030a7a28","646791b0a28e6c06f696fb77","6541205377b2190a15527a17","6541205377b2190a15527a18","6541205377b2190a15527a19","6541205377b2190a15527a1a","6509e98612ea3a000bb40411","6509ebf786c93f004507384d","6541205377b2190a15527a1b","6541205377b2190a15527a1c","6541205377b2190a15527a1d","6541205377b2190a15527a1e","653c13fe786fd60065f449ee","6541205377b2190a15527aa1","656f601bf9bd75003e2078b0","6570958208334100eec412b0","65b57fe5064162003155a1a4","65bbca3b7adc2c00383c87d1","65c6898486578e000eecdfd1","65ccf81b9aba0000299887cb","6619430f18098e005e7a5cf5","66196f81a0dfe200360d753c","662aa1074daa7c005c035876","66c6362a025d0c005a28909d","66ec1e913784117131dfdd3e","66edc55f2fc54a005e4a0540","6709930cf504a7006e20c2d6","670fc31b87db74003dbf9546","6711742526344c004d5d6c2b","67117484fd7d140011c3a8d7","671175cdfd7d140011c3a8ec","67117e82522a4b001e7e1678","67192d04d3bf5a006919e7c8","683a02bfab1a560061005eda","683a20b779a72f001e39c578","683a22489d0bb90056ff0cc4","683f22ca4e01cd0044152160","685c4ee41b672d0060f4b4f3","68fbd52691cffd91ac050a3d","68ff7a6c68ccccb9a245b351"],"project":"5d63dabecc03470056f9c570","createdAt":"2023-10-31T15:42:10.972Z","releaseDate":"2019-08-26T13:12:30.117Z","__v":4,"forked_from":"653c13fe786fd60065f449ec","updatedAt":"2026-03-30T17:30:32.383Z","apiRegistries":[{"filename":"ordergroove-restrpc.json","uuid":"jqx21mvmkbf1d9c"},{"filename":"ordergroove-payment-api.json","uuid":"x4ryrmk8xnqpr"},{"filename":"ordergroove-webhooks-api.json","uuid":"x4r1mmmkb8lkth"},{"filename":"ordergroove-cart-management-api.json","uuid":"3s622tlona0k2o"},{"filename":"ordergroove-entitlements-service-api.json","uuid":"37hxpmndgrqr1"},{"filename":"payment_attempt_data_api.yaml","uuid":"c3qf1ommwbmg3y"}],"pdfStatus":"complete","source":"readme"},{"_id":"6995ef0db2d60a2407d2eb72","project":"5d63dabecc03470056f9c570","version":"2.10.1-gplplay","version_clean":"2.10.1-gplplay","codename":"","is_stable":false,"is_beta":false,"is_hidden":false,"is_deprecated":false,"forked_from":"6541205377b2190a15527a9f","categories":[],"pdfStatus":"","apiRegistries":[{"filename":"ordergroove-restrpc.json","uuid":"jqx21mvmkbf1d9c"},{"filename":"ordergroove-payment-api.json","uuid":"x4ryrmk8xnqpr"},{"filename":"ordergroove-webhooks-api.json","uuid":"x4r1mmmkb8lkth"},{"filename":"ordergroove-cart-management-api.json","uuid":"3s622tlona0k2o"},{"filename":"ordergroove-entitlements-service-api.json","uuid":"93hy1k1mkb8hz2g"}],"source":"readme","createdAt":"2026-02-18T16:55:41.014Z","releaseDate":"2026-02-18T16:55:41.015Z","updatedAt":"2026-02-20T22:00:58.912Z","__v":0}],"variableDefaults":[{"name":"x-api-key","default":"5Yqx6wYK6sEnSdXbrQq4tj3N5yiFxE6JWQkdMvFcV8U4yCFjYub1ha4nEi48kGmMUhT5855Z1ecyW7fvVUAhLrJC","source":"","type":"","_id":"6962d00603bf8adacb9eabdf"},{"name":"X-OG-API-VERSION","default":"2","source":"","type":"","_id":"6962d00603bf8adacb9eabe0"},{"file":"ordergroove-webhooks-api.json","name":"api_key","source":"security","type":"apiKey","_id":"6965000c64e723272ef627ab"}],"webhookEnabled":false,"isHubEditable":true},"projectStore":{"data":{"allow_crawlers":"disabled","canonical_url":null,"default_version":{"name":"2.10.0"},"description":null,"git":{"repository_name":null,"connection":{"repository":null,"organization":null,"status":"none"},"remediation_status":null,"remediated_at":null,"remediation_initiated_by":null,"remediation_dry_run":null,"remediation_job_id":null},"glossary":[],"homepage_url":null,"created_at":null,"updated_at":null,"id":"5d63dabecc03470056f9c570","name":"Ordergroove API Reference","parent":null,"redirects":[],"sitemap":"disabled","llms_txt":"disabled","subdomain":"og-restrpc","suggested_edits":"disabled","notification_settings":{"project_topic_key":null},"uri":"/projects/me","variable_defaults":[{"name":"x-api-key","default":"5Yqx6wYK6sEnSdXbrQq4tj3N5yiFxE6JWQkdMvFcV8U4yCFjYub1ha4nEi48kGmMUhT5855Z1ecyW7fvVUAhLrJC","source":"","type":"","id":"6962d00603bf8adacb9eabdf"},{"name":"X-OG-API-VERSION","default":"2","source":"","type":"","id":"6962d00603bf8adacb9eabe0"},{"name":"api_key","source":"security","type":"apiKey","id":"6965000c64e723272ef627ab"}],"webhooks":[],"api_designer":{"allow_editing":"enabled"},"custom_login":{"jwt_expiration_time":0,"login_url":null,"logout_url":null},"features":{"mdx":"enabled"},"onboarding_completed":{"api":true,"appearance":true,"documentation":true,"domain":false,"jwt":true,"logs":false,"metricsSDK":false,"ai_ready":false},"pages":{"not_found":null,"default_visibility":"public"},"owner":{"id":null,"email":null,"name":null},"privacy":{"openapi":"admin","password":null,"view":"public"},"refactored":{"status":"enabled","migrated":"successful"},"seo":{"overwrite_title_tag":"disabled"},"metrics":{"monthly_purchase_limit":0,"monthly_limit":0},"feature_rules":{"merge":{"requirements":[],"allow_override":[]}},"god_mode":{"is_active":null,"flags":{},"admin_limit_override":null,"notes":null,"children_limit":null,"owlbot":{"enabled":null,"new_experience":null,"v2":null},"salesforce":{"account_id":null},"enterprise_notes":{"account_name":null,"owner_csm":null,"owner_sales":null,"status":null,"superhub_migration_eligibility":null}},"mcp":{"custom_tools":[],"disabled_routes":[],"disabled_tools":[],"has_password":false,"privacy":{"password":null}},"plan":{"type":"business2018","override":null,"stripe_subscription_id":null,"grace_period":{"enabled":false,"end_date":null},"trial":{"active":false,"enabled":null,"expired":false,"end_date":"2025-12-01T17:28:50.503Z"}},"reference":{"api_sdk_snippets":"enabled","experimental_performance_mode":"disabled","defaults":"always_use","json_editor":"disabled","method_badge_style":"modern","oauth_flows":"disabled","request_history":"enabled","request_examples":"collapsed","response_examples":"collapsed","response_schemas":"collapsed","show_method_in_sidebar":"enabled","sdk_snippets":{"external":"disabled"}},"ai":{"chat":{"models":[],"knowledge":{"custom_knowledge":null,"use_project_knowledge":false}},"owlbot":{"enabled":true,"new_experience":true,"v2":false,"is_paying":true,"trial":{"is_paying":false}}},"health_check":{"provider":"none","settings":{"manual":{"status":"down","url":null},"statuspage":{"id":null}}},"integrations":{"aws":{"readme_webhook_login":{"region":null,"external_id":null,"role_arn":null,"usage_plan_id":null}},"bing":{"verify":null},"google":{"analytics":null,"site_verification":null},"heap":{"id":null},"koala":{"key":null},"localize":{"key":null},"postman":{"key":null,"client_id":null,"client_secret":null,"is_connected":false},"recaptcha":{"site_key":null,"secret_key":null},"segment":{"key":null,"domain":null},"speakeasy":{"key":null,"spec_url":null},"stainless":{"key":null,"name":null},"typekit":{"key":null},"zendesk":{"subdomain":null},"intercom":{"app_id":null,"secure_mode":{"key":null,"email_only":false}}},"permissions":{"appearance":{"private_label":"enabled","custom_code":{"css":"enabled","html":"enabled","js":"disabled"}},"branches":{"merge":{"admin":true,"editor":false},"approve":{"admin":true,"editor":false}}},"appearance":{"brand":{"primary_color":"#493e90","link_color":"#219050","link_color_dark":"#219050","theme":"system"},"changelog":{"layout":"collapsed","show_author":true,"show_exact_date":false},"layout":{"full_width":"disabled","style":"compact"},"markdown":{"callouts":{"icon_font":"emojis"}},"table_of_contents":"enabled","whats_next_label":null,"landing_page":{"sections":[{"type":"html","alignment":"left","title":null,"text":null,"html":"    \u003cheader class=\"header-area\">\n        \u003cdiv class=\"home-container\">\n            \u003cdiv class=\"header-wrapper\">\n                \u003cdiv class=\"header-left\">\n                    \u003cdiv class=\"header-menu\">\n                        \u003cul>\n                            \u003cli>\u003ca href=\"https://developer.ordergroove.com/\">Home\u003c/a>\u003c/li>\n                            \u003cli>\u003ca href=\"https://developer.ordergroove.com/docs\">Guides\u003c/a>\u003c/li>\n                            \u003cli>\u003ca href=\"https://developer.ordergroove.com/reference\">API Reference\u003c/a>\u003c/li>\n                        \u003c/ul>\n                    \u003c/div>\n                \u003c/div>\n                \u003cdiv class=\"header-right\">\n                    \u003cdiv class=\"logo\">\n                        \u003ca href=\"#\">\u003cimg src=\"https://files.readme.io/81f3860-logo.svg\" alt=\"\">\u003c/a>\n                    \u003c/div>\n                \u003c/div>\n            \u003c/div>\n        \u003c/div>\n    \u003c/header>\n\n\n\n\n    \u003c!-------------- Hero Area Start ------------->\n    \u003csection class=\"hero-area\">\n        \u003cdiv class=\"home-container\">\n          \u003cdiv class=\"hero-wrapper\">\n                \u003cdiv class=\"hero-left\">\n                    \u003cdiv class=\"hero__text\">\n                        \u003ch1>Start building with \u003cbr> the \u003cspan class=\"gradient__text\">Ordergroove API\u003c/span>\u003c/h1>\n                        \u003cp>Build your custom subscription experience that delights, growing recurring \n                            revenue to unprecedented heights.\u003c/p>\n                        \u003cdiv class=\"hero__btn\">\n                            \u003ca href=\"https://developer.ordergroove.com/docs/developer-fundamentals\" class=\"custom--btn\">Explore Guides\u003c/a>\n                        \u003c/div>\n                    \u003c/div>\n                \u003c/div>\n                \u003cdiv class=\"hero-right\">\n                    \u003cimg src=\"https://files.readme.io/79cf655-Visuals.svg\" alt=\"\">\n                \u003c/div>\n            \u003c/div>\n        \u003c/div>\n        \u003cimg src=\"https://files.readme.io/eea4d90-shp.svg\" class=\"hero-shp\" alt=\"\">\n        \u003cimg src=\"https://files.readme.io/1dc9cd9-hero-shp-2.png\" class=\"hero-shp-2\" alt=\"\">\n    \u003c/section>\n    \u003c!-------------- Hero Area End ------------->\n\n\n    \n    \u003c!-------------- Brand Area Start ------------->\n    \u003cdiv class=\"brand-area\">\n        \u003cdiv class=\"home-container\">\n            \u003cdiv class=\"brand-wrapper\">\n                \u003cdiv class=\"brand-item\">\n                    \u003cimg src=\"https://files.readme.io/4a0ee1f-cliff-logo_1.png\" alt=\"\">\n                \u003c/div>\n                \u003cdiv class=\"brand-item\">\n                    \u003cimg src=\"https://files.readme.io/eb0827b-daily-harvest-logo.png\" alt=\"\">\n                \u003c/div>\n                \u003cdiv class=\"brand-item\">\n                    \u003cimg src=\"https://files.readme.io/eb75e8b-dollar-shave-club-logo.png\" alt=\"\">\n                \u003c/div>\n              \u003c!--\n                \u003cdiv class=\"brand-item\">\n                    \u003cimg src=\"https://files.readme.io/d310e42-organifi.png\" alt=\"\">\n                \u003c/div>\n\t\t\t\t\t\t\t-->\n                \u003cdiv class=\"brand-item\">\n                    \u003cimg src=\"https://files.readme.io/eefd116-honest-2.png\" alt=\"\">\n                \u003c/div>\n                \u003cdiv class=\"brand-item\">\n                    \u003cimg src=\"https://files.readme.io/31753c3-LOreal_Logo.png\" alt=\"\">\n                \u003c/div>\n                \u003cdiv class=\"brand-item\">\n                    \u003cimg src=\"https://files.readme.io/7955915-G-Fuel-Logo.png\" alt=\"\">\n                \u003c/div>\n                \u003cdiv class=\"brand-item\">\n                    \u003cimg src=\"https://files.readme.io/1abd232-peets-logo.png\" alt=\"\">\n                \u003c/div>\n            \u003c/div>\n        \u003c/div>\n    \u003c/div>\n    \n    \u003c!-------------- Brand Area End ------------->\n\n   \n    \n    \u003c!-------------- Get Started Area Start ------------->\n    \u003cdiv class=\"get-started-area\">\n        \u003cdiv class=\"home-container\">\n            \u003cdiv class=\"area-title\">\n                \u003ch2>Get Started\u003c/h2>\n            \u003c/div>\n            \u003cdiv class=\"card-wrapper\">\n                \u003cdiv class=\"about-card\">\n                    \u003cdiv class=\"about-card-inner\">\n                        \u003cdiv class=\"icon-box\">\n                            \u003cimg src=\"https://files.readme.io/91d3c3e-star.svg\" alt=\"\">\n                            \u003cimg src=\"https://files.readme.io/df12502-Icon-bg.png\" class=\"icon-bg\" alt=\"\">\n                        \u003c/div>\n                        \u003ch2>Getting Started\u003c/h2>\n                        \u003cp>Get started with Ordergroove’s Data Model, Systems Landscape Map, and Authentication.\u003c/p>\n                        \u003cdiv class=\"card-btn\">\n                            \u003ca href=\"https://developer.ordergroove.com/docs/developer-fundamentals\">Start Here \u003cimg src=\"https://files.readme.io/86d0a34-ArrowRight.svg\" alt=\"\">\u003c/a>\n                        \u003c/div>\n                    \u003c/div>\n                \u003c/div>\n                \u003cdiv class=\"about-card\">\n                    \u003cdiv class=\"about-card-inner\">\n                        \u003cdiv class=\"icon-box\">\n                            \u003cimg src=\"https://files.readme.io/97cc15a-MagicWand.svg\" alt=\"\">\n                            \u003cimg src=\"https://files.readme.io/df12502-Icon-bg.png\" class=\"icon-bg\" alt=\"\">\n                        \u003c/div>\n                        \u003ch2>Guides\u003c/h2>\n                        \u003cp>Read detailed guides to help quickly launch custom subscription experiences. \u003c/p>\n                        \u003cdiv class=\"card-btn\">\n                            \u003ca href=\"https://developer.ordergroove.com/docs/developer-fundamentals\">Explore Guides \u003cimg src=\"https://files.readme.io/86d0a34-ArrowRight.svg\" alt=\"\">\u003c/a>\n                        \u003c/div>\n                    \u003c/div>\n                \u003c/div>\n                \u003cdiv class=\"about-card\">\n                    \u003cdiv class=\"about-card-inner\">\n                        \u003cdiv class=\"icon-box\">\n                            \u003cimg src=\"https://files.readme.io/8d75fa2-file-code.svg\" alt=\"\">\n                            \u003cimg src=\"https://files.readme.io/df12502-Icon-bg.png\" class=\"icon-bg\" alt=\"\">\n                        \u003c/div>\n                        \u003ch2>API Docs\u003c/h2>\n                        \u003cp>A technical guide to integrating with the Ordergroove Relationship Commerce Cloud outside our hosted experiences.\u003c/p>\n                        \u003cdiv class=\"card-btn\">\n                            \u003ca href=\"https://developer.ordergroove.com/reference/introduction\">Read API Docs \u003cimg src=\"https://files.readme.io/86d0a34-ArrowRight.svg\" alt=\"\">\u003c/a>\n                        \u003c/div>\n                    \u003c/div>\n                \u003c/div>\n            \u003c/div>\n        \u003c/div>\n    \u003c/div>\n    \n    \u003c!-------------- Get Started Area End ------------->\n\n\n    \u003c!-------------- Subscription Area Start ------------->\n    \u003cdiv class=\"subscription-area\">\n        \u003cdiv class=\"home-container\">\n            \u003cdiv class=\"subscription-wrapper\">\n                \u003cdiv class=\"subscription-content\">\n                    \u003ch5>Subscription Partners\u003c/h5>\n                    \u003ch2>Memorable subscription experiences, \u003cbr> built better \u003cspan class=\"gradient-text-two\">together\u003c/span> \u003c/h2>\n                    \u003cp>Ordergroove partners with leading eCommerce agencies to create frictionless\n                        subscription experiences that delight shoppers and drive revenue.\u003c/p>\n                    \u003cdiv class=\"partner-btn\">\n                        \u003ca href=\"https://www.ordergroove.com/partners/\" class=\"custom--btn\">Partner with us\u003c/a>\n                    \u003c/div>\n                \u003c/div>\n                \u003cdiv class=\"subscription-thumb\">\n                    \u003cimg src=\"https://files.readme.io/470739f-img.png\" alt=\"\">\n                \u003c/div>\n            \u003c/div>\n        \u003c/div>\n    \u003c/div>\n    \u003c!-------------- Subscription Area End ------------->\n\n\n\n\n    \u003c!-------------- Footer Area Start ------------->\n  \u003csection class=\"home-footer\">\n        \u003cdiv class=\"home-container\">\n            \u003cdiv class=\"footer-wrapper\">\n                \u003cdiv class=\"footer-left\">\n                    \u003cdiv class=\"footer-logo\">\n                        \u003ca href=\"#\">\u003cimg src=\"https://files.readme.io/81f3860-logo.svg\" alt=\"\">\u003c/a>\n                    \u003c/div>\n                    \u003cdiv class=\"footer-left-content\">\n                        \u003cp>Putting relationships at the center of commerce to help all merchants thrive.\u003c/p>\n                        \u003cp>382 NE 191st Street, Suite 56661 \u003cbr>\n                            Miami, FL 33179\u003c/p>\n                    \u003c/div>\n                    \n                    \u003c!-------- FORM FOR EMAIL\n                    \u003cdiv class=\"subscription-form\">\n                        \u003clabel for=\"\">GET UPDATES\u003c/label>\n                        \u003cdiv class=\"subscription-box\">\n                            \u003cinput type=\"text\" placeholder=\"your email\">\n                            \u003cbutton>\u003cimg src=\"https://files.readme.io/86d0a34-ArrowRight.svg\" alt=\"\">\u003c/button>\n                        \u003c/div>\n                    \u003c/div>\n                   FORM FOR EMAIL ------------->\n                \n                \u003c/div>\n                \u003cdiv class=\"footer-right\">\n                    \u003cdiv class=\"footer-widget\">\n                        \u003ch3>Product\u003c/h3>\n                        \u003cdiv class=\"footer-links\">\n                            \u003cul>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/product/why-ordergroove/\">Why Ordergroove\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/product/subscription-incentives/\">Incentives\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/product/subscriber-experience/\">Subscriber Experience\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/product/subscription-performance/\">Performance\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/integrations/\">Integrations\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/product/subscription-first-experiences/\">Subscription-first Experiences\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/product/support/\">Customer Success &amp; Support\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/demo/\">Get Started\u003c/a>\u003c/li>\n                            \u003c/ul>\n                        \u003c/div>\n                    \u003c/div>\n                    \u003cdiv class=\"footer-widget\">\n                        \u003ch3>Solutions\u003c/h3>\n                        \u003cdiv class=\"footer-links\">\n                            \u003cdiv class=\"subtitle\">\n                                \u003ch4>BY STRATEGY\u003c/h4>\n                            \u003c/div>\n                            \u003cul>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/solutions/launch-subscriptions/\">Launch Subscriptions\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/solutions/migrate/\">Migrate to Ordergroove\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/solutions/scale-subscriptions/\">Scale Subscriptions\u003c/a>\u003c/li>\n                            \u003c/ul>\n                        \u003c/div>\n                        \u003cdiv class=\"footer-links\">\n                            \u003cdiv class=\"subtitle\">\n                                \u003ch4>BY PLATFORM\u003c/h4>\n                            \u003c/div>\n                            \u003cul>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/integrations/shopify-plus/\">Shopify Plus\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/integrations/commercetools/\">Commercetools\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/integrations/shopify/\">Shopify\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/integrations/salesforce/\">Salesforce\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/integrations/magento/\">Magento\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/integrations/bigcommerce/\">BigCommerce\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/integrations/adobe-commerce/\">Adobe Commerce\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/integrations/custom/\">Custom Cart\u003c/a>\u003c/li>\n                            \u003c/ul>\n                        \u003c/div>\n                    \u003c/div>\n                    \u003cdiv class=\"footer-widget\">\n                        \u003ch3>Company\u003c/h3>\n                        \u003cdiv class=\"footer-links\">\n                            \u003cul>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/contact/\">Contact\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/careers/\">Careers\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/company/leadership/\">Leadership\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/press/\">Press\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/partners/\">Partners\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/security/\">Security\u003c/a>\u003c/li>\n                            \u003c/ul>\n                        \u003c/div>\n                        \u003cdiv class=\"footer-links\">\n                            \u003ch3>Resources\u003c/h3>\n                            \u003cul>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/blog/\">Blog\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/case-studies/\">Case Studies\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/webinars/\">Webinars\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://www.ordergroove.com/resources/\">Guides &amp; Reports\u003c/a>\u003c/li>\n                                \u003cli>\u003ca href=\"https://ordergroove.zendesk.com/hc/en-us\">Knowledge Center\u003c/a>\u003c/li>\n                            \u003c/ul>\n                        \u003c/div>\n                    \u003c/div>\n                \u003c/div>\n            \u003c/div>\n            \u003cdiv class=\"row\">\n                \u003cdiv class=\"col-lg-12\">\n                    \u003cdiv class=\"footer-bottom-wrapper\">\n                        \u003cdiv class=\"copyright-text\">\n                            \u003cp>© 2024 Ordergroove. All rights reserved.\u003c/p>\n                        \u003c/div>\n                        \u003cdiv class=\"social-links\">\n                            \u003cul class=\"social flex a-c\">\n                              \u003cli>\n                                \u003ca href=\"https://www.facebook.com/OrderGroove/\" title=\"Link to Ordergroove's Facebook\" target=\"_blank\" aria-label=\"Link to Ordergroove's Facebook\">\u003csvg width=\"8\" height=\"16\" viewBox=\"0 0 8 16\" fill=\"none\" xmlns=\"http://www.w3.org/2000/svg\">\u003cpath d=\"M5.19532 15.8638H2.38282V8.36377H0.507818V5.78564H2.38282V4.28565C2.38282 2.17627 2.94532 0.910647 5.42969 0.910647H7.49219V3.48877H6.17968C5.19531 3.48877 5.14844 3.86377 5.14844 4.52002V5.83252H7.49219L7.21094 8.41065H5.14844L5.19532 15.8638Z\" fill=\"#D8D7DF\">\u003c/path>\u003c/svg>\u003c/a>\n                              \u003c/li>\n                              \u003cli>\n                                \u003ca href=\"https://www.linkedin.com/company/ordergroove-inc.\" title=\"Link to Ordergroove's Linkedin\" target=\"_blank\" aria-label=\"Link to Ordergroove's Linkedin\">\u003c!--?xml version=\"1.0\" encoding=\"utf-8\"?-->\u003csvg width=\"14\" height=\"14\" viewBox=\"0 0 14 14\" fill=\"none\" xmlns=\"http://www.w3.org/2000/svg\"> \u003cpath d=\"M3.38031 2.22818C3.38031 3.01868 2.79784 3.64274 1.84093 3.64274C0.925614 3.64274 0.34314 3.01868 0.34314 2.22818C0.34314 1.43769 0.925614 0.813599 1.84093 0.813599C2.79784 0.813599 3.33871 1.43769 3.38031 2.22818ZM0.426349 13.9608V4.80768H3.2555V13.9608H0.426349ZM5.00291 7.72004C5.00291 6.5967 4.96131 5.63978 4.9197 4.80768H7.37441L7.49922 6.09745H7.54083C7.91527 5.51498 8.83058 4.59965 10.37 4.59965C12.2422 4.59965 13.6568 5.84781 13.6568 8.55214V13.9608H10.8276V8.885C10.8276 7.72006 10.4116 6.88793 9.37145 6.88793C8.58095 6.88793 8.12329 7.42882 7.91527 7.96968C7.83206 8.1361 7.83206 8.42734 7.83206 8.67697V13.9608H5.00291V7.72004Z\" fill=\"#D8D7DF\">\u003c/path> \u003c/svg> \u003c/a>\n                              \u003c/li>\n                              \u003cli>\n                                \u003ca href=\"https://twitter.com/ordergroove\" title=\"Link to Ordergroove's Twitter\" target=\"_blank\" aria-label=\"Link to Ordergroove's Twitter\">\u003c!--?xml version=\"1.0\" encoding=\"utf-8\"?-->\u003csvg width=\"16\" height=\"13\" viewBox=\"0 0 16 13\" fill=\"none\" xmlns=\"http://www.w3.org/2000/svg\"> \u003cpath d=\"M15.7576 1.53403C15.1776 1.77791 14.5976 1.97301 13.9209 2.02179C14.5976 1.63158 15.0809 0.997491 15.3226 0.265852C14.6943 0.65606 14.0176 0.899942 13.2926 1.04627C12.7126 0.412183 11.8909 0.0219727 10.9725 0.0219727C9.23249 0.0219727 7.78246 1.43648 7.78246 3.24119C7.78246 3.48507 7.83079 3.72895 7.87913 3.97283C5.22074 3.8265 2.90069 2.55832 1.354 0.607282C1.06399 1.09504 0.91899 1.63158 0.91899 2.21689C0.91899 3.33874 1.499 4.31425 2.32068 4.89956C1.789 4.89956 1.30566 4.75324 0.870653 4.50936V4.55813C0.870653 6.11896 1.98234 7.38713 3.43237 7.67979C3.14237 7.72857 2.9007 7.77734 2.61069 7.77734C2.41735 7.77734 2.22402 7.77735 2.03068 7.72857C2.41736 8.99674 3.62571 9.92348 4.97907 9.97226C3.91571 10.8502 2.51402 11.338 1.01566 11.338C0.773986 11.338 0.483984 11.338 0.242313 11.2892C1.64401 12.216 3.3357 12.7525 5.12407 12.7525C10.9725 12.7525 14.1626 7.87489 14.1626 3.63139C14.1626 3.48506 14.1626 3.33874 14.1626 3.24119C14.7909 2.70465 15.3709 2.16812 15.7576 1.53403Z\" fill=\"#D8D7DF\">\u003c/path> \u003c/svg> \u003c/a>\n                              \u003c/li>\n                              \u003cli>\n                                \u003ca href=\"https://apps.shopify.com/ordergroove\" title=\"Link to Ordergroove's Shopify App\" target=\"_blank\" aria-label=\"Link to Ordergroove's Shopify App\">\u003csvg width=\"15\" height=\"17\" viewBox=\"0 0 15 17\" fill=\"none\" xmlns=\"http://www.w3.org/2000/svg\"> \u003cpath fill-rule=\"evenodd\" clip-rule=\"evenodd\" d=\"M12.9888 3.13432C13.051 3.1395 13.126 3.18712 13.1378 3.27296C13.1496 3.3588 15 15.8699 15 15.8699L10.4645 16.9974L0 15.1875C0 15.1875 1.24871 5.53174 1.29492 5.19177C1.35717 4.74188 1.37225 4.72726 1.84948 4.57731C1.85963 4.57403 2.18152 4.47434 2.6939 4.31567C2.9194 4.24584 3.18178 4.16459 3.47073 4.0751C3.57163 3.3522 3.92767 2.41849 4.39547 1.6753C5.06038 0.618994 5.88042 0.0243505 6.70377 0.000772282C7.13055 -0.01196 7.48656 0.132811 7.76432 0.429895C7.78413 0.45159 7.80299 0.473751 7.82186 0.496386C7.82659 0.495984 7.83132 0.495576 7.83604 0.495168C7.87554 0.491758 7.91475 0.488372 7.95436 0.488372H7.95671C8.59428 0.489312 9.12196 0.852889 9.48222 1.54043C9.59398 1.75358 9.67228 1.96579 9.72557 2.13838C9.80673 2.11325 9.87949 2.09072 9.94287 2.0711C10.1281 2.01377 10.2332 1.98123 10.2339 1.98087C10.3098 1.95824 10.5051 1.92806 10.605 2.02803C10.705 2.128 11.717 3.11075 11.717 3.11075C11.717 3.11075 12.927 3.12913 12.9888 3.13432ZM8.3896 2.55194L9.20165 2.30059C9.07196 1.87902 8.76451 1.17214 8.13968 1.05378C8.33396 1.55505 8.38348 2.13508 8.3896 2.55194ZM6.09498 3.26259L7.84212 2.7217C7.84778 2.26664 7.79826 1.59372 7.5705 1.11838C7.32811 1.21835 7.12347 1.3933 6.97729 1.55033C6.584 1.97239 6.26379 2.61607 6.09498 3.26259ZM7.21542 0.678411C7.0763 0.586928 6.9136 0.544486 6.72026 0.54873C5.44939 0.585512 4.34077 2.57033 4.05733 3.89308C4.31745 3.81275 4.59056 3.72814 4.87123 3.64118C5.07496 3.57806 5.28267 3.51371 5.49231 3.44886C5.65217 2.60853 6.053 1.73755 6.57598 1.17638C6.7778 0.959936 6.99284 0.793945 7.21542 0.678411ZM7.42189 7.43734L7.94861 5.46669C7.94861 5.46669 7.4945 5.24034 6.60701 5.2974C4.30344 5.44264 3.25937 7.05351 3.35983 8.64314C3.42684 9.70435 4.05206 10.148 4.60006 10.5368C5.02756 10.8402 5.40806 11.1102 5.43988 11.614C5.45733 11.8918 5.28475 12.2846 4.80186 12.3152C4.06244 12.3619 3.13866 11.6649 3.13866 11.6649L2.78545 13.1673C2.78545 13.1673 3.70312 14.1505 5.37011 14.0454C6.75885 13.9577 7.72274 12.8467 7.62042 11.2226C7.54169 9.97393 6.66237 9.41011 5.96738 8.96448C5.51331 8.67333 5.13793 8.43263 5.11594 8.08435C5.10554 7.92259 5.11639 7.27844 6.13782 7.21382C6.83432 7.16997 7.42189 7.43734 7.42189 7.43734Z\" fill=\"#D8D7DF\">\u003c/path> \u003c/svg> \u003c/a>\n                              \u003c/li>\n                            \u003c/ul>\n                \n                        \u003c/div>\n                    \u003c/div>\n                \u003c/div>\n            \u003c/div>\n        \u003c/div>\n    \u003c/section>\n    \u003c!-------------- Footer Area End ------------->","page_type":null,"side":null,"media_type":null,"media_html":null,"media_image":null,"media_code":null,"group0":null,"group1":null,"group2":null}],"promo":{"title":"Ordergroove Dev Docs","text":"Build your custom subscription experience that delights, growing recurring revenue to unprecedented heights.","content_type":"none","html":null,"button_primary":"docs","button_secondary":"reference"}},"footer":{"readme_logo":"show"},"logo":{"size":"default","dark_mode":{"uri":"/images/6986216513536a76cb673f22","url":"https://files.readme.io/6569eeaca64d5940a1ed6368578c3ab19fbf6af30bce973b8eaa377ba656021d-short_black_bg.png","name":"6569eeaca64d5940a1ed6368578c3ab19fbf6af30bce973b8eaa377ba656021d-short_black_bg.png","width":554,"height":189,"color":"#24cc6c","links":{"original_url":null}},"main":{"uri":"/images/698cc7a33f7f42194dab77de","url":"https://files.readme.io/6fdeecee3b160d06768dc696c4c0fe8ebd672b51f1e65e1e54e375a42893c599-short_white_bg.png","name":"6fdeecee3b160d06768dc696c4c0fe8ebd672b51f1e65e1e54e375a42893c599-short_white_bg.png","width":554,"height":189,"color":"#24cc6c","links":{"original_url":null}},"favicon":{"uri":"/images/698cc7a7d6e7f8a533b52f17","url":"https://files.readme.io/ee510bc0f7c463612c51d58e576398fdb238ce0348a94eafa28cc22d29e08a0f-favicon.png","name":"ee510bc0f7c463612c51d58e576398fdb238ce0348a94eafa28cc22d29e08a0f-favicon.png","width":82,"height":82,"color":"#23c469","links":{"original_url":null}}},"typography":{"heading_font":null,"body_font":null,"code_font":null,"spacing":null,"custom_heading":{"url":null,"filename":null,"format":null},"custom_code":{"url":null,"filename":null,"format":null},"custom_body":{"regular":{"url":null,"filename":null,"format":null},"medium":{"url":null,"filename":null,"format":null},"semibold":{"url":null,"filename":null,"format":null}}},"ai":{"dropdown":"enabled","options":{"ask_ai":"enabled","chatgpt":"enabled","claude":"enabled","clipboard":"disabled","view_as_markdown":"disabled","mcp":{"command":"enabled","config":"enabled","cursor":"enabled","vscode":"enabled"}}},"custom_code":{"css":"@import url('https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100;0,300;0,400;0,500;0,700;0,900;1,100;1,300;1,400;1,500;1,700;1,900&display=swap');\n/* Base CSS */\n\n@font-face {\n    font-family: \"Inter\";\n    src: url(\"https://use.typekit.net/af/59b013/00000000000000007735a1aa/30/l?primer=7cdcb44be4a7db8877ffa5c0007b8dd865b3bbc383831fe2ea177f62257a9191&fvd=n5&v=3\") format(\"woff2\"),url(\"https://use.typekit.net/af/59b013/00000000000000007735a1aa/30/d?primer=7cdcb44be4a7db8877ffa5c0007b8dd865b3bbc383831fe2ea177f62257a9191&fvd=n5&v=3\") format(\"woff\"),url(\"https://use.typekit.net/af/59b013/00000000000000007735a1aa/30/a?primer=7cdcb44be4a7db8877ffa5c0007b8dd865b3bbc383831fe2ea177f62257a9191&fvd=n5&v=3\") format(\"opentype\");\n    font-display: auto;\n    font-style: normal;\n    font-weight: 500;\n    font-stretch: normal;\n}\n\n@font-face {\n    font-family: \"InterSemibold\";\n    src: url(\"https://use.typekit.net/af/3ec29d/00000000000000007735a1b1/30/l?primer=7cdcb44be4a7db8877ffa5c0007b8dd865b3bbc383831fe2ea177f62257a9191&fvd=n4&v=3\") format(\"woff2\"),url(\"https://use.typekit.net/af/3ec29d/00000000000000007735a1b1/30/d?primer=7cdcb44be4a7db8877ffa5c0007b8dd865b3bbc383831fe2ea177f62257a9191&fvd=n4&v=3\") format(\"woff\"),url(\"https://use.typekit.net/af/3ec29d/00000000000000007735a1b1/30/a?primer=7cdcb44be4a7db8877ffa5c0007b8dd865b3bbc383831fe2ea177f62257a9191&fvd=n4&v=3\") format(\"opentype\");\n    font-display: auto;\n    font-style: normal;\n    font-weight: 400;\n    font-stretch: normal;\n}\n\n@font-face {\n    font-family: \"InterSemibold\";\n    src: url(\"https://use.typekit.net/af/fd801b/00000000000000007735a1b6/30/l?primer=7cdcb44be4a7db8877ffa5c0007b8dd865b3bbc383831fe2ea177f62257a9191&fvd=n6&v=3\") format(\"woff2\"),url(\"https://use.typekit.net/af/fd801b/00000000000000007735a1b6/30/d?primer=7cdcb44be4a7db8877ffa5c0007b8dd865b3bbc383831fe2ea177f62257a9191&fvd=n6&v=3\") format(\"woff\"),url(\"https://use.typekit.net/af/fd801b/00000000000000007735a1b6/30/a?primer=7cdcb44be4a7db8877ffa5c0007b8dd865b3bbc383831fe2ea177f62257a9191&fvd=n6&v=3\") format(\"opentype\");\n    font-display: auto;\n    font-style: normal;\n    font-weight: 600;\n    font-stretch: normal;\n}\n\n@font-face {\n    font-family: \"InterBold\";\n    src: url(\"https://use.typekit.net/af/5d2da8/00000000000000007735a1ac/30/l?primer=7cdcb44be4a7db8877ffa5c0007b8dd865b3bbc383831fe2ea177f62257a9191&fvd=n7&v=3\") format(\"woff2\"),url(\"https://use.typekit.net/af/5d2da8/00000000000000007735a1ac/30/d?primer=7cdcb44be4a7db8877ffa5c0007b8dd865b3bbc383831fe2ea177f62257a9191&fvd=n7&v=3\") format(\"woff\"),url(\"https://use.typekit.net/af/5d2da8/00000000000000007735a1ac/30/a?primer=7cdcb44be4a7db8877ffa5c0007b8dd865b3bbc383831fe2ea177f62257a9191&fvd=n7&v=3\") format(\"opentype\");\n    font-display: auto;\n    font-style: normal;\n    font-weight: 700;\n    font-stretch: normal;\n}\n\n.hub-is-home .rm-Header {\n  display: none !important;\n}\n\n*{\n    margin: 0;\n    padding: 0;\n    box-sizing: border-box;\n}\n\n/* Nav Menu Icons */\n#ssr-main > div > div.SuperHub2RNxzk6HzHiJ > div > div.ContentWithOwlbot-content2X1XexaN8Lf2 > header > div.Header-bottom2eLKOFXMEmh5.Header-bottom_compact.rm-Header-bottom.Header-bottom_withOwlbot3wuKp8NLXCqs > div > nav > a:nth-child(6) > span,\n#ssr-main > div > div.SuperHub2RNxzk6HzHiJ > div > div.ContentWithOwlbot-content2X1XexaN8Lf2 > header > div.Header-bottom2eLKOFXMEmh5.Header-bottom_compact.rm-Header-bottom.Header-bottom_withOwlbot3wuKp8NLXCqs > div > nav > a:nth-child(7) > span {\n    position: relative;\n    padding-right: 20px;\n}\n\nheader div > nav > a[href^=\"https://\"] > span::before {\n    content: ' ';\n    position: absolute;\n    display: block;\n    right: 0;\n    top: 2px;\n    background-image: url(\"data:image/svg+xml,\u003csvg width='16' height='16' viewBox='0 0 16 16' fill='none' xmlns='http://www.w3.org/2000/svg'>\u003cpath d='M7.25 2H4.25C3.00736 2 2 3.00735 2 4.24999V11.75C2 12.9926 3.00736 14 4.25 14H11.75C12.9926 14 14 12.9926 14 11.75V8.74996M10.2496 2.00018L14 2M14 2V5.37507M14 2L7.62445 8.37478' stroke-width='1.5' stroke-linecap='round' stroke='%2317132f' stroke-linejoin='round'/>\u003c/svg>\");\n    height: 16px;\n    width: 16px;\n}\n\n[data-color-mode=dark] header div > nav > a:nth-child(6) > span::before,\n[data-color-mode=dark] header div > nav > a:nth-child(7) > span::before {\n    background-image: url('data:image/svg+xml,\u003csvg width=\"16\" height=\"16\" viewBox=\"0 0 16 16\" fill=\"none\" xmlns=\"http://www.w3.org/2000/svg\"> \u003cpath d=\"M7.25 2H4.25C3.00736 2 2 3.00735 2 4.24999V11.75C2 12.9926 3.00736 14 4.25 14H11.75C12.9926 14 14 12.9926 14 11.75V8.74996M10.2496 2.00018L14 2M14 2V5.37507M14 2L7.62445 8.37478\" stroke=\"white\" stroke-width=\"1.5\" stroke-linecap=\"round\" stroke-linejoin=\"round\"/> \u003c/svg>');\n}\n\n.rm-Sidebar-heading {\n  font-size: 14px !important;\n    color: #17132f !important;\n}\n\n.rm-Sidebar-link {\n    color: #514e63 !important;\n}\n\n.rm-Sidebar-link.active {\n    color: #188c48 !important;\n}\n\n[data-color-mode=dark] .rm-Sidebar-heading {\n    color: white !important;\n}\n\n[data-color-mode=dark] .rm-Sidebar-link {\n    color: #c7c6cd !important;\n}\n\n[data-color-mode=dark] .rm-Sidebar-link.active {\n    color: #51e18d !important;\n}\n\n[data-color-mode=dark] .rm-SearchToggle {\n    background-color: #17132f !important;\n}\n\n.alignleft {\n    float: left;\n    margin-right: 15px;\n}\n\n.alignright {\n    float: right;\n    margin-left: 15px;\n}\n\n.aligncenter {\n    display: block;\n    margin: 0 auto 15px;\n}\n\na:focus {\n    outline: 0 solid\n}\n\nimg {\n    max-width: 100%;\n    height: auto;\n}\n\nh1,\nh2,\nh3,\nh4,\nh5,\nh6 {\n    margin: 0 0 15px;\n    font-family: 'Inter', Roboto;\n    margin-bottom: 15px;\n}\n\nbody {\n      color: #2D2D2D;\n    font-weight: 400;\n    font-family: \"Inter\", sans-serif;\n    line-height: 1.428;\n}\n\n[data-color-mode=dark] body {\n    background-color: #17132F;\n}\n\n\n[data-color-mode=dark] header.rm-Header {\n  background-color: #131024;\n}\n\n.selector-for-some-widget {\n    box-sizing: content-box;\n}\n  a.custom--btn:hover,\n  .card-btn a:hover {\n      text-decoration: none !important;\n  }\n\n  a,\n  button,\n  input,\n  textarea {\n      outline: none !important;\n\n  }\n  a, button{\n      border: none;\n      text-decoration: none;\n  }\n\n  p{\n      margin-bottom: 15px;\n  }\n\n.section-padding {\n    padding: 80px 0;\n}\n\n.rm-LandingPage {\n  width: 100%;\n  min-width: 100%;\n  padding: 0;\n}\n\n.home-container {\n    width: 1200px;\n    padding: 0 15px;\n    margin: 0 auto;\n}\n\n.header-wrapper {\n    display: flex;\n    align-items: center;\n    justify-content: space-between;\n}\n.header-left {\n    width: 40%;\n}\n.header-right {\n    width: 60%;\n}\n.logo a {\n    display: inline-block;\n}\n.logo a img {\n    max-height: 32px;\n}\n.logo a {\n    display: inline-block;\n    line-height: 1;\n}\n\n.logo a img {\n    max-height: 32px;\n}\n\n.header-menu ul {\n    margin: 0;\n    padding: 0;\n    list-style: none;\n    position: relative;\n    top: -3px;\n}\n\n.header-menu ul li {\n    display: inline-block;\n    margin-right: 40px;\n}\n\n.header-menu ul li a {\n    display: inline-block;\n    color: #fff;\n    font-size: 14px;\n    letter-spacing: .3px;\n    transition: .3s;\n    font-family: 'Inter', Roboto;\n}\n.header-menu ul li a:hover{\n    color: #00FF85;\n}\n\n.header-area {\n  background: #17132F;\n  position: absolute;\n  left: 0;\n  top: 0;\n  width: 100%;\n  z-index: 99;\n  transition: .3s;\n  padding: 30px 0;\n}\n.hero-area {\n    background: #17132F;\n    height: 850px;\n    display: flex;\n    align-items: center;\n    padding-top: 90px;\n    overflow: hidden;\n    position: relative;\n    z-index: 1;\n}\n.hero-wrapper {\n    display: flex;\n    align-items: center;\n    justify-content: space-between;\n}\n.hero__text h1 {\n    font-family: 'Inter', Roboto;\n    font-size: 65px;\n    color: #fff;\n    line-height: 130%;\n    letter-spacing: -2px;\n    margin-bottom: 20px;\n}\n.hero__text {\n    max-width: 660px;\n}\n.hero-left {\n    width: 60%;\n}\n.hero-right {\n    width: 40%;\n    text-align: right;\n}\n.hero-right img {\n    width: 100%;\n    position: relative;\n    top: -30px;\n}\n\n.gradient__text{\n    display: inline-block;\n    background: linear-gradient(to right top, #00fe8f, #00ffb4, #00ffd4, #00fdec, #01fafe);\n    -webkit-background-clip: text;\n    -webkit-text-fill-color: transparent;\n}\n.hero__text p {\n    font-size: 21px;\n    color: #FFFFFF;\n    font-weight: normal;\n    line-height: 150%;\n} \n.hero__btn {\n    margin-top: 40px;\n}\n\n.custom--btn  {\n    border: 1px solid #00FF85;\n    color: #000 !important;\n    text-decoration: none;\n    display: inline-block;\n    padding: 11px 32px;\n    border-radius: 40px;\n    font-size: 18px;\n    font-family: 'Inter', Roboto;\n    line-height: 101%;\n    background: #00FF85;\n    padding-top: 14px;\n    transition: .3s;\n}\n.custom--btn:hover{\n    background-color: transparent;\n    color: #00FF85 !important;\n}\n.hero-shp {\n    position: absolute;\n    right: 0;\n    bottom: -78%;\n    z-index: -1;\n    width: 1000px;\n}\nimg.hero-shp-2 {\n    position: absolute;\n    left: 0;\n    width: 65%;\n    top: 90px;\n    z-index: -2;\n}\n.brand-wrapper {\n    display: flex;\n    align-items: center;\n    justify-content: space-between;\n    gap: 0 10px;\n}\n.brand-item {\n    max-height: 95px;\n    display: flex;\n    align-items: center;\n    justify-content: center;\n    padding: 5px 5px;\n}\n.brand-area {\n    background: #FFFFFF;\n    padding: 15px 0;\n}\n\n.get-started-area {\n    padding: 90px 0;\n    background: #F5FFF9;\n    position: relative;\n}\n.area-title {\n    margin-bottom: 40px;\n    text-align: center;\n}\n.area-title h2 {\n    color: #000000;\n    font-size: 38px;\n    font-family: 'Inter', Roboto;\n}\n.about-card {\n    position: relative;\n    padding: 40px 30px;\n    height: 355px;\n    display: flex;\n    align-items: center;\n    justify-content: center;\n    text-align: center;\n    border-radius: 20px;\n    z-index: 1;\n    box-shadow: 0px 16px 8px 0px rgba(23, 19, 47, 0.1);\n    max-width: 360px;\n    margin: 0 auto;\n    transition: .3s;\n}\n.about-card:before {\n    position: absolute;\n    left: 50%;\n    top: 50%;\n    content: '';\n    z-index: -2;\n    background: #fff;\n    border-radius: 19px;\n    transform: translate(-50%, -50%);\n    height: calc(100% - 5px);\n    width: calc(100% - 5px);\n}\n.about-card:after {\n    position: absolute;\n    left: 0;\n    top: 0;\n    width: 100%;\n    height: 100%;\n    background-image: linear-gradient(to right bottom, #00faff, #00daff, #00b3ff, #007fff, #8500ff);\n    content: '';\n    border-radius: 20px;\n    z-index: -3;\n}\n.icon-bg {\n    position: absolute;\n    left: 0;\n    height: 100%;\n    top: 0;\n    width: 100%;\n    z-index: -1;\n}\n.icon-bg {\n    position: absolute;\n    left: 0;\n    height: 100%;\n    top: 0;\n    width: 100%;\n    z-index: -1;\n}\n.icon-box {\n    display: inline-flex;\n    align-items: center;\n    justify-content: center;\n    width: 82px;\n    height: 82px;\n    margin-bottom: 25px;\n    z-index: 1;\n    position: relative;\n    font-size: 0px;\n}\n.icon-box:before {\n  content: \"\";\n}\n.about-card-inner h2 {\n    font-size: 28px;\n    color: #2D2D2D;\n    font-weight: 600;\n}\n.about-card-inner p {\n  font-size: 16px;\n  color: #2D2D2D;\n  min-height: 72px;\n}\n.card-btn a {\n    display: inline-flex;\n    justify-content: center;\n    color: #8500FF;\n    font-size: 18px;\n    text-decoration: none;\n    align-items: center;\n    font-family: 'Inter', Roboto;\n    gap:0 10px\n}\n.card-wrapper {\n    display: grid;\n    grid-template-columns: repeat(3, calc(33.33% - 13px));\n    gap: 0 20px;\n}\n.card-btn img {\n    width: 18px;\n    position: relative;\n    top: -1px;\n}\n\n\n\n\n\n\n.subscription-area {\n    padding: 120px 0;\n    position: relative;\n}\n.subscription-wrapper {\n    padding: 40px;\n    position: relative;\n    border-radius: 30px 0 30px 30px;\n    position: relative;\n    z-index: 1;\n    padding-right: 0;\n    display: flex;\n    align-items: center;\n    justify-content: space-between;\n}\n.subscription-wrapper:after {\n    position: absolute;\n    left: 0;\n    top: 0;\n    width: calc(100% - 50px);\n    background: #17132F;\n    content: '';\n    height: 100%;\n    z-index: -1;\n    border-radius: 30px 0 30px 30px;\n}\n.subscription-content {\n    padding-left: 10px;\n    width: 60%;\n}\n.subscription-thumb {\n    text-align: right;\n    width: 40%;\n}\n.subscription-thumb img {\n    max-width: 420px;\n}\n.subscription-content h5 {\n    display: block;\n    color: #00FF85;\n    font-size: 14px;\n    text-transform: uppercase;\n    letter-spacing: .3px;\n}\n.subscription-content h2 {\n    color: #fff;\n    line-height: 125%;\n    font-size: 30px;\n    font-family: 'Inter', Roboto;\n}\n.subscription-content p {\n    max-width: 450px;\n    color: #fff;\n}\n.partner-btn {\n    margin-top: 30px;\n}\n\n.gradient-text-two{\n    display: inline-block;\n    background-image: linear-gradient(to right, #19eba1, #00d4db, #00b4ff, #0088ff, #782bf6);\n    -webkit-background-clip: text;\n    -webkit-text-fill-color: transparent;\n}\n\n/* XL Device :1200px. */\n@media (min-width: 1200px) and (max-width: 1449px) {\n    .hero-area {\n        height: 780px;\n    }\n\n    img.hero-shp-2 {\n        width: 60%;\n        top: 80px;\n    }\n\n    .hero-shp {\n        bottom: -82%;\n        width: 905px;\n    }\n\n\n\n\n}\n\n\n\n\n@media (min-width: 1200px) and (max-width: 1300px) {\n    .hero-area {\n        height: 760px;\n    }\n\n    .hero-shp {\n        bottom: -85%;\n        width: 880px;\n        right: -50px\n    }\n\n    .home-container {\n        width: 1170px;\n    }\n\n}\n\n\n\n\n\n\n\n/* LG Device :992px. */\n@media (min-width: 992px) and (max-width: 1200px) {\n    .home-container {\n        width: 100%;\n    }\n\n    .subscription-thumb img {\n        max-width: 360px;\n    }\n\n    .subscription-content {\n        padding-left: 15px;\n    }\n\n    .subscription-wrapper {\n        padding: 32px 20px;\n        padding-right: 0;\n    }\n\n    .custom--btn {\n        font-size: 16px;\n    }\n\n    .brand-item img {\n        max-height: 60px;\n    }\n\n    .hero-area {\n        height: 640px;\n        padding-top: 80px;\n    }\n\n    .hero__text h1 {\n        font-size: 55px;\n        line-height: 120%;\n    }\n\n    .hero__text p {\n        font-size: 19px;\n    }\n\n    .hero__btn {\n        margin-top: 35px;\n    }\n\n    .logo a img {\n        max-height: 28px;\n    }\n\n    .hero-shp {\n        bottom: -78%;\n        width: 760px;\n        right: -10%;\n    }\n\n    .icon-box {\n        width: 75px;\n        height: 74px;\n        margin-bottom: 20px;\n    }\n\n    .about-card {\n        padding: 28px 22px;\n        height: 320px;\n        border-radius: 16px;\n        max-width: 360px;\n    }\n\n    .about-card:before {\n        border-radius: 17px;\n    }\n\n    .about-card:after {\n        border-radius: 16px;\n    }\n\n    .about-card-inner h2 {\n        font-size: 24px;\n    }\n\n    .about-card-inner p {\n        font-size: 15px;\n    }\n\n    footer {\n        padding-top: 60px;\n        padding-bottom: 20px;\n    }\n\n\n\n\n\n\n}\n\n\n@media (min-width: 768px) and (max-width: 991px) {\n    .home-container {\n        width: 100%;\n    }\n\n    .header-menu ul li {\n        display: inline-block;\n        margin-right: 30px;\n    }\n\n    .logo a img {\n        max-height: 25px;\n    }\n\n    .logo {\n        text-align: right;\n    }\n    .subscription-thumb img {\n        max-width: 100%;\n        width: 100%;\n    }\n    .subscription-content {\n        padding-left: 0;\n        width: 60%;\n        padding-right: 25px;\n    }\n    .subscription-wrapper {\n        padding: 30px;\n        padding-right: 0;\n    }\n    .subscription-content h2 {\n        font-size: 22px;\n    }\n    .subscription-content p {\n        font-size: 14px;\n    }\n    .custom--btn {\n        padding: 10px 28px;\n        border-radius: 40px;\n        font-size: 15px;\n        line-height: 101%;\n        padding-top: 13px;\n    }\n    .hero__text h1 {\n        font-size: 45px;\n    }\n    .hero__text p {\n        font-size: 16px;\n    }\n    .hero__btn {\n        margin-top: 30px;\n    }\n    .hero-area {\n        height: 550px;\n        padding-top: 70px;\n    }\n    .hero-shp {\n        right: -14%;\n        bottom: -77%;\n        width: 600px;\n    }\n    img.hero-shp-2 {\n        width: 60%;\n        top: 77px;\n    }\n    .about-card {\n        padding: 25px 15px;\n        height: 280px;\n    }\n    .icon-box {\n        width: 64px;\n        height: 64px;\n        margin-bottom: 15px;\n    }\n    .about-card-inner h2 {\n        font-size: 20px;\n        margin-bottom: 10px;\n    }\n    .about-card-inner p {\n        font-size: 14px;\n    }\n    .card-btn a {\n        font-size: 15px;\n        gap: 0 8px;\n    }\n    .area-title h2 {\n        font-size: 30px;\n    }\n    .icon-bg {\n        position: absolute;\n        left: 0;\n        height: 100%;\n        top: 0;\n        width: 100%;\n        z-index: -1;\n    }\n    .icon-box img:first-child {\n        width: 36px;\n    }\n    .subscription-area {\n        padding: 80px 0;\n    }\n    .footer-logo img {\n        max-height: 28px;\n    }\n    .subscription-box {\n        height: 38px;\n    }\n    \n\n\n}\n\n\n\n\n/* SM Small Device :320px. */\n@media only screen and (max-width: 767px) {\n    .brand-wrapper {\n        gap: 20px 10px;\n        flex-wrap: wrap;\n    }\n    .brand-item {\n        height: 140px;\n        padding: 5px 5px;\n        display: flex;\n        align-items: center;\n        justify-content: center;\n        margin-bottom: 20px;\n    }\n    .card-wrapper {\n        display: grid;\n        grid-template-columns: repeat(1, calc(100%));\n        gap: 0 20px;\n    }\n    .about-card{\n        margin-bottom: 25px;\n    }\n    .footer-wrapper {\n        display: block; \n    }\n    .home-container {\n        width: 100%;\n        padding: 0 15px;\n        margin: 0 auto;\n    }\n    .subscription-thumb img {\n        max-width: 100%;\n    }\n    .subscription-thumb {\n        display: none;\n    }\n    .subscription-content {\n        padding-left: 0;\n        width: 100%;\n    }\n    .subscription-wrapper:after {\n        width: 100%;\n        height: 100%;\n        z-index: -1;\n        border-radius: 16px;\n    }\n    .subscription-wrapper:after {\n        border-radius: 40px;\n        padding: 035px 25px;\n    }\n    .subscription-content h2 {\n        font-size: 20px;\n    }\n    .subscription-content h2 {\n        color: #fff;\n        font-size: 20px;\n        font-family: 'Inter';\n    }\n    .logo a img {\n        max-height: 20px;\n    }\n    .header-menu ul li {\n        margin-right: 12px;\n    }\n    .header-menu ul li a {\n        font-size: 13px;\n    }\n    .hero__text h1 {\n        font-size: 28px;\n    }\n    .hero-wrapper {\n        display: block;\n    }\n    .hero-left {\n        width: 100%;\n    }\n    .hero-area {\n        height: auto;\n        padding-top: 70px;\n        padding-bottom: 70px;\n    }\n    .hero-wrapper {\n        text-align: center;\n    }\n    .hero-right img {\n        width: 320px;\n        position: relative;\n        top: 0;\n    }\n    .hero__text p {\n        font-size: 16px;\n    }\n    .hero-right {\n        width: 100%;\n        text-align: center;\n        margin-top: 50px;\n    }\n    .hero-right img {\n        width: 200px;\n        position: relative;\n    }\n\n    .header-left {\n        width: 85%;\n    }\n    .logo {\n        text-align: right;\n    }\n    .header-right {\n        width: 40%;\n    }\n    .hero-wrapper {\n        display: flex;\n        flex-direction: column-reverse;\n    }\n    .hero-left {\n        margin-top: 50px;\n    }\n    .brand-item img {\n        max-height: 70px;\n    }\n    .brand-wrapper {\n        gap: 0 10px;\n        flex-wrap: wrap;\n    }\n    .brand-item {\n        padding: 5px 5px;\n        justify-content: center;\n        margin-bottom: 20px;\n    }\n    .brand-item {\n        padding: 9px 5px;\n        justify-content: center;\n        margin-bottom: 10px;\n    }\n    .brand-item img {\n        width: 70px;\n    }\n    .brand-item {\n        height: 69px;\n        padding: 5px 5px;\n        margin-bottom: 20px;\n    }\n    .brand-item {\n        height: 60px;\n    }\n    .get-started-area {\n        padding: 60px 0;\n    }\n    .subscription-wrapper {\n        padding: 30px;\n        z-index: 1;\n        padding-right: 0;\n        background: #000;\n        border-radius: 15px !important;\n    }\n    .subscription-wrapper:after {\n        border-radius: 40px;\n        width: 100%;\n    }\n    .subscription-area {\n        padding: 90px 0;\n    }\n    .footer-left {\n        width: 100%;\n        margin-bottom: 35px;\n    }\n    .footer-widget {\n        width: 100%;\n    }\n    .footer-right {\n        width: 100%;\n    }\n    .subscription-wrapper:after {\n        display: none;\n    }\n    .footer-right {\n        width: 100%;\n        display: block;\n    }\n    .footer-bottom-wrapper {\n        display: block;\n        text-align: center;\n    }\n    .social-links{\n        text-align: center;\n        margin-top: 25px;\n    }\n    .social-links {\n        display: flex;\n        justify-content: center;\n        align-items: center;\n        margin-top: 25px;\n    }\n    .footer-logo {\n        margin-bottom: 15px;\n        width: 150px;\n    }\n    .subscription-form{\n        display: block;\n    }\n    .footer-right {\n        margin-top: 50px;\n    }\n    .subscription-wrapper {\n        padding: 30px;\n        z-index: 1;\n        padding-right: 0;\n        background: #000;\n        border-radius: 15px !important;\n    }\n    .area-title h2 {\n        font-size: 28px;\n    }\n    .custom--btn {\n        padding-top: 14px;\n    }\n    .brand-item img {\n        width: 85px;\n    }\n\n}\n\n\n/* SM Small Device :550px. */\n@media only screen and (min-width: 576px) and (max-width: 767px) {}\n\n/* footer styles */\n.home-footer {\n    background: #17132F;\n    padding-top: 80px;\n    padding-bottom: 50px;\n\n    .subscription-form {\n        margin-top: 70px;\n    }\n    .subscription-form label {\n        color: #D8D7DF;\n        font-size: 10px;\n        margin-bottom: 10px;\n        font-family: 'Inter';\n        letter-spacing: .3px;\n    }\n    .subscription-box input {\n        width: 100%;\n        height: 100%;\n        border-radius: 40px;\n        border: none;\n        color: #666279;\n        padding: 8px 16px;\n        line-height: 1;\n        font-size: 12px;\n        font-family: 'Inter';\n    }\n    .subscription-box button {\n        position: absolute;\n        right: 12px;\n        top: 50%;\n        background: transparent;\n        border: none;\n        cursor: pointer;\n        transform: translateY(-50%);\n        padding: 0;\n        margin-top: -2px;\n    }\n    .footer-left-content {\n        max-width: 220px;\n    }\n    .footer-logo {\n        margin-bottom: 15px;\n    }\n    .footer-left-content p {\n        color: #ABA9BA;\n        font-size: 12px;\n        line-height: 130%;\n        font-family: 'Inter';\n    }\n    .subscription-box {\n        position: relative;\n        width: 220px;\n        height: 38px;\n    }\n    .subscription-form label {\n        color: #D8D7DF;\n        font-size: 10px;\n        margin-bottom: 10px;\n        font-family: 'Inter';\n        letter-spacing: .3px;\n        display: block;\n    }\n    .footer-widget h3 {\n        font-size: 14px;\n        color: #fff;\n        display: block;\n        padding-bottom: 10px;\n        border-bottom: 1px solid #4F4A6A;\n        max-width: 165px;\n        margin-bottom: 20px;\n    }\n    .footer-links {\n        margin-bottom: 35px;\n    }\n    .footer-links ul {\n        margin: 0;\n        padding: 0;\n        list-style: none;\n    }\n    .footer-links ul li {\n        display: block;\n        margin-bottom: 7px;\n        font-size: 12px;\n        color: #ABA9BA;\n    }\n    .footer-links ul li a {\n        display: block;\n        color: #ABA9BA;\n        text-decoration: none;\n        font-size: 12px;\n        letter-spacing: .3px;\n        transition: .3s;\n        font-family: 'Inter';\n    }\n    .footer-links li a:hover {\n        color: #00FF85;\n    }\n    .subtitle h4 {\n        font-size: 10px;\n        color: #EBEAF0;\n        text-transform: uppercase;\n        font-family: 'Inter';\n        margin-bottom: 12px;\n    }\n    .footer-left {\n        width: 32%;\n    }\n    .footer-right {\n        width: 68%;\n        display: flex;\n        gap: 0 15px;\n    }\n    .footer-wrapper {\n        display: flex;\n        justify-content: space-between;\n        align-items: flex-start;\n    }\n    .footer-widget {\n        width: 33.33%;\n    }\n    .copyright-text p {\n        color: #787688;\n        font-size: 12px;\n        letter-spacing: .2px;\n        margin: 0;\n        font-family: 'Inter';\n    }\n    .social-links {\n        display: flex;\n        justify-content: flex-end;\n        align-items: center;\n    }\n    .social-links ul {\n        margin: 0;\n        padding: 0;\n        list-style: none;\n    }\n    .social-links ul li {\n        display: inline-block;\n        margin-left: 10px;\n    }\n    .social-links ul li a {\n        display: inline-flex;\n        width: 33px;\n        height: 33px;\n        background: #2E2A47;\n        align-items: center;\n        justify-content: center;\n        border-radius: 100%;\n        transition: .3s;\n        border: 1px solid #2E2A47;\n    }\n    .footer-bottom-wrapper {\n        padding-top: 25px;\n        padding-bottom: 10px;\n        border-top: 1px solid #2E2A47;\n        display: flex;\n        align-items: center;\n        justify-content: space-between;\n        gap: 0 15px;\n    }\n    \n    .subscription-box button {\n        position: absolute;\n        right: 12px;\n        top: 50%;\n        background: transparent;\n        border: none;\n        cursor: pointer;\n        transform: translateY(-50%);\n        padding: 0;\n        margin-top: 2px;\n    }\n}\n\n/* CUSTOM Changes\n\n/* Disable code wrapping and enable horizontal scroll */\n.markdown-body pre, \n.markdown-body pre > code {\n    white-space: pre !important;\n    overflow-x: auto !important;\n    word-break: normal !important;\n    word-wrap: normal !important;\n}\n\n/* 1. Prevent text from wrapping in all table cells */\n.rdmd-table th, \n.rdmd-table td {\n  white-space: nowrap !important;\n  padding: 12px 15px; /* Optional: adds some breathing room */\n}\n\n/* 2. Ensure the table container allows horizontal scrolling */\n.rdmd-table-inner {\n  overflow-x: auto !important;\n  display: block;\n  width: 100%;\n}\n\n\n/* ───────────────────────────────────────────────────────────────\n   GraphQL API Docs — Custom CSS for README.io\n   Paste this into: Appearance > Custom CSS/JS > Custom CSS\n   All rules scoped under .gql-docs to avoid conflicts.\n   ─────────────────────────────────────────────────────────────── */\n\n/* Align README.io page title with our full-width layout */\n.rm-CustomPage > div:has(.gql-docs) {\n  width: 100vw;\n  padding: 0 40px;\n  box-sizing: border-box;\n}\n\n.gql-docs {\n  --gql-border: #e1e3e5;\n  --gql-text: #1a1a1a;\n  --gql-text-muted: #616161;\n  --gql-text-link: #0057b8;\n  --gql-accent: #008060;\n  --gql-badge-required: #d72c0d;\n  --gql-badge-bg-required: #fef0ee;\n  --gql-font-mono: 'SF Mono', SFMono-Regular, Consolas, 'Liberation Mono', Menlo, monospace;\n  line-height: 1.6;\n  /* Break out of README.io's narrow container */\n  width: 100vw;\n  margin-left: calc(-50vw + 50%);\n  padding: 0 40px;\n  box-sizing: border-box;\n}\n\n/* ── Page title ── */\n.gql-docs h1 code {\n  font-family: var(--gql-font-mono);\n  font-weight: 600;\n  background: none;\n  padding: 0;\n}\n.gql-docs .gql-subtitle {\n  font-size: 15px;\n  color: var(--gql-text-muted);\n  margin-bottom: 24px;\n}\n.gql-docs .gql-description {\n  font-size: 15px;\n  line-height: 1.7;\n  margin-bottom: 24px;\n}\n.gql-docs .gql-description ul {\n  margin: 12px 0;\n  padding-left: 24px;\n}\n.gql-docs .gql-description li {\n  margin-bottom: 4px;\n}\n.gql-docs .gql-callout {\n  background: #f6f6f7;\n  border-left: 3px solid var(--gql-accent);\n  border-radius: 4px;\n  padding: 12px 16px;\n  font-size: 14px;\n  margin-bottom: 24px;\n  color: var(--gql-text-muted);\n}\n\n/* ── Section headings ── */\n.gql-docs .gql-section-heading {\n  font-size: 20px;\n  font-weight: 600;\n  margin-top: 40px;\n  margin-bottom: 16px;\n  padding-bottom: 8px;\n  border-bottom: 1px solid var(--gql-border);\n}\n\n/* ── Arguments ── */\n.gql-docs .gql-arg-list {\n  list-style: none;\n  margin: 0;\n  padding: 0;\n}\n.gql-docs .gql-arg-item {\n  padding: 12px 0;\n  border-bottom: 1px solid var(--gql-border);\n}\n.gql-docs .gql-arg-item:last-child {\n  border-bottom: none;\n}\n.gql-docs .gql-arg-header {\n  display: flex;\n  align-items: center;\n  gap: 8px;\n  margin-bottom: 4px;\n}\n.gql-docs .gql-arg-name {\n  font-family: var(--gql-font-mono);\n  font-size: 14px;\n  font-weight: 600;\n  color: var(--gql-text);\n}\n.gql-docs .gql-type-tag {\n  font-family: var(--gql-font-mono);\n  font-size: 13px;\n  color: var(--gql-text-link);\n}\n.gql-docs .gql-badge {\n  font-size: 11px;\n  font-weight: 600;\n  padding: 1px 6px;\n  border-radius: 3px;\n  text-transform: uppercase;\n  letter-spacing: 0.5px;\n  display: inline-block;\n}\n.gql-docs .gql-badge-required {\n  color: var(--gql-badge-required);\n  background: var(--gql-badge-bg-required);\n}\n.gql-docs .gql-badge-non-null {\n  color: var(--gql-accent);\n  background: #e3f4ef;\n}\n.gql-docs .gql-arg-desc {\n  font-size: 14px;\n  color: var(--gql-text-muted);\n}\n\n/* ── Field list ── */\n.gql-docs .gql-field-list {\n  list-style: none;\n  margin: 0;\n  padding: 0;\n}\n.gql-docs .gql-field-item {\n  border-bottom: 1px solid var(--gql-border);\n}\n.gql-docs .gql-field-row {\n  display: flex;\n  align-items: baseline;\n  gap: 8px;\n  padding: 10px 0;\n  flex-wrap: wrap;\n}\n.gql-docs .gql-field-name {\n  font-family: var(--gql-font-mono);\n  font-size: 14px;\n  font-weight: 600;\n  color: var(--gql-text);\n}\n.gql-docs .gql-field-desc {\n  font-size: 13px;\n  color: var(--gql-text-muted);\n  flex-basis: 100%;\n  margin-top: 2px;\n}\n\n/* ── Nested / expandable types ── */\n.gql-docs details.gql-nested-type {\n  border-bottom: 1px solid var(--gql-border);\n}\n.gql-docs details.gql-nested-type > summary {\n  display: flex;\n  align-items: center;\n  gap: 8px;\n  padding: 10px 0;\n  cursor: pointer;\n  list-style: none;\n  flex-wrap: wrap;\n}\n.gql-docs details.gql-nested-type > summary::-webkit-details-marker {\n  display: none;\n}\n.gql-docs details.gql-nested-type > summary::before {\n  content: '\\25B8';\n  font-size: 12px;\n  color: var(--gql-text-muted);\n  transition: transform 0.15s;\n  flex-shrink: 0;\n}\n.gql-docs details.gql-nested-type[open] > summary::before {\n  transform: rotate(90deg);\n}\n.gql-docs details.gql-nested-type > .gql-nested-content {\n  padding: 0 0 8px 20px;\n  border-left: 2px solid var(--gql-border);\n  margin-left: 4px;\n  margin-bottom: 8px;\n}\n.gql-docs .gql-nested-type-heading {\n  font-size: 13px;\n  font-weight: 600;\n  color: var(--gql-text-muted);\n  text-transform: uppercase;\n  letter-spacing: 0.5px;\n  margin-bottom: 4px;\n  padding-top: 4px;\n}\n.gql-docs .gql-show-fields {\n  font-size: 12px;\n  color: var(--gql-text-link);\n  margin-left: auto;\n}\n.gql-docs details.gql-nested-type[open] > summary .gql-show-fields {\n  display: none;\n}\n\n/* ── Left navigation ── */\n.gql-docs .gql-nav {\n  width: 200px;\n  flex-shrink: 0;\n}\n.gql-docs .gql-nav-inner {\n  position: sticky;\n  top: 20px;\n}\n.gql-docs .gql-nav-section {\n  border: none;\n}\n.gql-docs .gql-nav-section > summary {\n  font-size: 11px;\n  font-weight: 700;\n  text-transform: uppercase;\n  letter-spacing: 0.8px;\n  color: var(--gql-text-muted);\n  padding: 6px 0;\n  cursor: pointer;\n  list-style: none;\n}\n.gql-docs .gql-nav-section > summary::-webkit-details-marker {\n  display: none;\n}\n.gql-docs .gql-nav-list {\n  list-style: none;\n  margin: 0;\n  padding: 0;\n}\n.gql-docs .gql-nav-link {\n  display: block;\n  font-family: var(--gql-font-mono);\n  font-size: 13px;\n  padding: 5px 12px;\n  color: var(--gql-text-muted);\n  text-decoration: none;\n  border-radius: 4px;\n}\n.gql-docs a.gql-nav-link:hover {\n  color: var(--gql-text);\n  background: #f6f6f7;\n}\n.gql-docs .gql-nav-active {\n  color: var(--gql-text);\n  font-weight: 600;\n  background: #f0f0f0;\n}\n\n/* ── Three-column layout ── */\n.gql-docs .gql-layout {\n  display: flex;\n  gap: 32px;\n  align-items: flex-start;\n}\n.gql-docs .gql-main {\n  flex: 1;\n  min-width: 0;\n}\n.gql-docs .gql-sidebar {\n  width: 380px;\n  flex-shrink: 0;\n  min-width: 0;\n}\n.gql-docs .gql-sidebar-inner {\n  position: sticky;\n  top: 20px;\n  max-height: 90vh;\n  overflow-y: auto;\n}\n.gql-docs .gql-sidebar-label {\n  font-size: 12px;\n  font-weight: 600;\n  color: #a0a0a0;\n  text-transform: uppercase;\n  letter-spacing: 0.8px;\n  padding: 10px 16px 0;\n  background: #1e1e1e;\n  border-radius: 6px 6px 0 0;\n}\n.gql-docs .gql-sidebar-label:nth-of-type(n+2) {\n  margin-top: 16px;\n}\n@media (max-width: 900px) {\n  .gql-docs .gql-nav {\n    display: none;\n  }\n  .gql-docs .gql-sidebar {\n    display: none;\n  }\n  .gql-docs .gql-layout {\n    display: block;\n  }\n}\n\n/* ── Code blocks ── */\n.gql-docs pre {\n  background: #1e1e1e;\n  color: #d4d4d4;\n  border-radius: 0 0 6px 6px;\n  padding: 16px 20px;\n  font-family: var(--gql-font-mono);\n  font-size: 13px;\n  line-height: 1.5;\n  overflow-x: auto;\n  margin-top: 0;\n  margin-bottom: 0;\n}\n.gql-docs pre.gql-code-standalone {\n  border-radius: 6px;\n}\n.gql-docs pre .kw { color: #569cd6; }\n.gql-docs pre .fl { color: #9cdcfe; }\n.gql-docs pre .st { color: #ce9178; }\n.gql-docs pre .vr { color: #dcdcaa; }\n.gql-docs pre .cm { color: #6a9955; }\n.gql-docs pre .nu { color: #b5cea8; }\n.gql-docs pre .br { color: #808080; }\n.gql-docs .gql-response-label {\n  font-size: 12px;\n  font-weight: 600;\n  color: #a0a0a0;\n  text-transform: uppercase;\n  letter-spacing: 0.8px;\n  padding: 12px 16px 0;\n  background: #1e1e1e;\n  margin-top: 2px;\n}\n\n/* ── Example sidebar ── */\n.gql-docs .gql-examples {\n  margin-bottom: 24px;\n}\n.gql-docs .gql-example-header {\n  font-size: 14px;\n  font-weight: 600;\n  color: var(--gql-text);\n  margin-bottom: 8px;\n}\n.gql-docs .gql-example-desc {\n  font-size: 13px;\n  color: var(--gql-text-muted);\n  margin: 0 0 8px;\n}\n\n/* ── Example selector (pills) ── */\n.gql-docs .gql-ex-select {\n  display: none;\n}\n.gql-docs .gql-ex-select-label {\n  display: inline-block;\n  padding: 4px 10px;\n  font-size: 12px;\n  font-weight: 600;\n  cursor: pointer;\n  color: var(--gql-text-muted);\n  background: #f0f0f0;\n  border: 1px solid var(--gql-border);\n  border-radius: 12px;\n  margin: 0 4px 8px 0;\n  transition: all 0.15s;\n}\n.gql-docs .gql-ex-select:checked + .gql-ex-select-label {\n  color: #fff;\n  background: var(--gql-accent);\n  border-color: var(--gql-accent);\n}\n.gql-docs .gql-examples > .gql-example {\n  display: none;\n}\n.gql-docs .gql-examples > input.gql-ex-select:nth-of-type(1):checked ~ .gql-example:nth-of-type(1) { display: block; }\n.gql-docs .gql-examples > input.gql-ex-select:nth-of-type(2):checked ~ .gql-example:nth-of-type(2) { display: block; }\n.gql-docs .gql-examples > input.gql-ex-select:nth-of-type(3):checked ~ .gql-example:nth-of-type(3) { display: block; }\n.gql-docs .gql-examples > input.gql-ex-select:nth-of-type(4):checked ~ .gql-example:nth-of-type(4) { display: block; }\n\n/* ── CSS-only language tabs ── */\n.gql-docs .gql-example-tabs {\n  border-radius: 6px;\n  overflow: hidden;\n}\n.gql-docs .gql-example-tabs input[type=\"radio\"] {\n  display: none;\n}\n.gql-docs .gql-example-tabs label {\n  display: inline-block;\n  padding: 6px 12px;\n  font-size: 12px;\n  font-weight: 600;\n  cursor: pointer;\n  color: #a0a0a0;\n  background: #1e1e1e;\n  border-bottom: 2px solid transparent;\n  margin: 0;\n}\n.gql-docs .gql-example-tabs input[type=\"radio\"]:checked + label {\n  color: #fff;\n  border-bottom-color: #569cd6;\n}\n.gql-docs .gql-example-panel {\n  display: none;\n}\n.gql-docs .gql-example-panel pre {\n  border-radius: 0 0 6px 6px;\n  max-height: 60vh;\n  overflow-y: auto;\n  scrollbar-width: thin;\n  scrollbar-color: #555 #1e1e1e;\n}\n.gql-docs .gql-example-panel pre::-webkit-scrollbar {\n  width: 6px;\n}\n.gql-docs .gql-example-panel pre::-webkit-scrollbar-track {\n  background: #1e1e1e;\n}\n.gql-docs .gql-example-panel pre::-webkit-scrollbar-thumb {\n  background: #555;\n  border-radius: 3px;\n}\n.gql-docs pre code {\n  display: block;\n  color: inherit;\n  background: none;\n  padding: 0;\n  font-size: inherit;\n  user-select: all;\n}\n.gql-docs .gql-example-tabs input:nth-of-type(1):checked ~ div:nth-of-type(1) { display: block; }\n.gql-docs .gql-example-tabs input:nth-of-type(2):checked ~ div:nth-of-type(2) { display: block; }\n.gql-docs .gql-example-tabs input:nth-of-type(3):checked ~ div:nth-of-type(3) { display: block; }\n.gql-docs .gql-example-tabs input:nth-of-type(4):checked ~ div:nth-of-type(4) { display: block; }\n\n\n/* ── Cross-link sidebar (type pages) ── */\n.gql-docs .gql-crosslinks {\n  margin-bottom: 24px;\n}\n.gql-docs .gql-crosslinks-heading {\n  font-size: 11px;\n  font-weight: 700;\n  text-transform: uppercase;\n  letter-spacing: 0.8px;\n  color: var(--gql-text-muted);\n  margin-bottom: 12px;\n}\n.gql-docs .gql-crosslinks-list {\n  list-style: none;\n  margin: 0;\n  padding: 0;\n}\n.gql-docs .gql-crosslinks-list li {\n  padding: 8px 0;\n  border-bottom: 1px solid var(--gql-border);\n}\n.gql-docs .gql-crosslinks-list li:last-child {\n  border-bottom: none;\n}\n.gql-docs .gql-crosslink {\n  display: block;\n  font-size: 14px;\n  font-weight: 500;\n  color: var(--gql-text-link);\n  text-decoration: none;\n}\n.gql-docs a.gql-crosslink:hover {\n  text-decoration: underline;\n}\n.gql-docs .gql-crosslink-query {\n  display: block;\n  font-family: var(--gql-font-mono);\n  font-size: 12px;\n  color: var(--gql-text-muted);\n  margin-top: 2px;\n}\n.gql-docs .gql-crosslink-details {\n  margin-top: 6px;\n}\n.gql-docs .gql-crosslink-details summary {\n  font-size: 12px;\n  font-weight: 600;\n  color: var(--gql-text-link);\n  cursor: pointer;\n}\n.gql-docs .gql-crosslink-details[open] summary {\n  margin-bottom: 8px;\n}\n\n/* ── Dark mode (README.io explicit dark) ── */\n[data-color-mode=\"dark\"] .gql-docs {\n  --gql-border: #333;\n  --gql-text: #e0e0e0;\n  --gql-text-muted: #999;\n  --gql-text-link: #58a6ff;\n  --gql-accent: #3fb980;\n  --gql-badge-required: #f97583;\n  --gql-badge-bg-required: #3d1a1e;\n}\n[data-color-mode=\"dark\"] .gql-docs .gql-badge-non-null { background: #1a3a2a; }\n[data-color-mode=\"dark\"] .gql-docs .gql-callout { background: #1e1e1e; }\n[data-color-mode=\"dark\"] .gql-docs a.gql-nav-link:hover { background: #2a2a2a; }\n[data-color-mode=\"dark\"] .gql-docs .gql-nav-active { background: #2a2a2a; }\n[data-color-mode=\"dark\"] .gql-docs .gql-ex-select-label { background: #2a2a2a; }\n[data-color-mode=\"dark\"] .gql-docs .gql-sidebar-label { background: #161616; }\n[data-color-mode=\"dark\"] .gql-docs .gql-response-label { background: #161616; }\n\n/* ── Dark mode (README.io system + OS dark) ── */\n@media (prefers-color-scheme: dark) {\n  [data-color-mode=\"system\"] .gql-docs {\n    --gql-border: #333;\n    --gql-text: #e0e0e0;\n    --gql-text-muted: #999;\n    --gql-text-link: #58a6ff;\n    --gql-accent: #3fb980;\n    --gql-badge-required: #f97583;\n    --gql-badge-bg-required: #3d1a1e;\n  }\n  [data-color-mode=\"system\"] .gql-docs .gql-badge-non-null { background: #1a3a2a; }\n  [data-color-mode=\"system\"] .gql-docs .gql-callout { background: #1e1e1e; }\n  [data-color-mode=\"system\"] .gql-docs a.gql-nav-link:hover { background: #2a2a2a; }\n  [data-color-mode=\"system\"] .gql-docs .gql-nav-active { background: #2a2a2a; }\n  [data-color-mode=\"system\"] .gql-docs .gql-ex-select-label { background: #2a2a2a; }\n  [data-color-mode=\"system\"] .gql-docs .gql-sidebar-label { background: #161616; }\n  [data-color-mode=\"system\"] .gql-docs .gql-response-label { background: #161616; }\n}","js":null,"html":{"header":"\u003clink rel=\"alternate\" type=\"text/markdown\" href=\"current_url.md\">","home_footer":null,"page_footer":"\u003cscript>\n    // workaround to make the nav links open in a new tab\n\t\tsetTimeout(() => {\n        document.querySelector(\"#ssr-main > div > div.SuperHub2RNxzk6HzHiJ > div > div.ContentWithOwlbot-content2X1XexaN8Lf2 > header > div.Header-bottom2eLKOFXMEmh5.Header-bottom_compact.rm-Header-bottom.Header-bottom_withOwlbot3wuKp8NLXCqs > div > nav > a:nth-child(6)\").setAttribute(\"target\", \"_blank\");\n        document.querySelector(\"#ssr-main > div > div.SuperHub2RNxzk6HzHiJ > div > div.ContentWithOwlbot-content2X1XexaN8Lf2 > header > div.Header-bottom2eLKOFXMEmh5.Header-bottom_compact.rm-Header-bottom.Header-bottom_withOwlbot3wuKp8NLXCqs > div > nav > a:nth-child(7)\").setAttribute(\"target\", \"_blank\");\n    }, 3000);\n \u003c/script>"}},"header":{"type":"line","gradient_color":null,"link_style":"tabs","overlay":{"fill":"auto","type":"triangles","position":"top-left","image":{"uri":null,"url":null,"name":null,"width":null,"height":null,"color":null,"links":{"original_url":null}}}},"navigation":{"collapsible_categories":"enabled","breadcrumbs":"enabled","first_page":"reference","left":[],"logo_link":"landing_page","page_icons":"enabled","right":[],"sub_nav":[{"type":"link_url","title":"Knowledge Center","url":"https://help.ordergroove.com/hc/en-us","custom_page":null},{"type":"link_url","title":"Academy","url":"https://academy.ordergroove.com/hc/en-us","custom_page":null}],"subheader_layout":"links","version":"disabled","links":{"home":{"label":"Home","visibility":"disabled"},"graphql":{"label":"GraphQL","visibility":"disabled","schema":null},"guides":{"label":"Guides","alias":null,"visibility":"enabled"},"reference":{"label":"API Reference","alias":null,"visibility":"enabled"},"recipes":{"label":"Recipes","alias":null,"visibility":"disabled"},"changelog":{"label":"Changelog","alias":null,"visibility":"disabled"},"discussions":{"label":"Discussions","alias":null,"visibility":"disabled"}}}},"i18n":{"languages":["en"],"defaultLanguage":"en","state":"disabled"}}},"version":{"_id":"6541205377b2190a15527a9f","version":"2.10.0","version_clean":"2.10.0","codename":"","is_stable":true,"is_beta":false,"is_hidden":false,"is_deprecated":false,"categories":["5d63dabecc03470056f9c575","6541205377b2190a15527a07","5d63de895179b9004cf25083","6541205377b2190a15527a08","6541205377b2190a15527a09","6541205377b2190a15527a0a","6541205377b2190a15527a0b","6541205377b2190a15527a0c","6541205377b2190a15527a0d","6541205377b2190a15527a0e","6541205377b2190a15527a0f","6541205377b2190a15527a10","6541205377b2190a15527a11","6541205377b2190a15527a12","6541205377b2190a15527a13","5d7900c7d202e7003baec4b9","5d790119b3a9600024df0154","5da5e2cbc9b875004c79804f","5dc976352c62b30047202bcf","5dcc503bd6d997002e28a2fc","5ddc07a83604cd004a95db37","6541205377b2190a15527a15","5f74b18f26833a004fb62c9c","6541205377b2190a15527a16","600895cdd4fedc001ea6e230","600896a80742ab004868158f","6011a019ec3e230011f40f46","6011a18d86276d00127aa69c","6011a27603c6b10056bd6681","6011a542e07e9f003a1938ca","6011a6e90ac1c2004008f867","6011b6335d8879006ea33d33","6011b6f8702e6e00397c2568","6011b71d01538900728b57fa","6011b885ec85810065f1e0db","6011b9865b40f800335ea54c","6011bc459f9939002791ee38","6011bf675bb4f3002c1b1225","6011c1876febb20073b944f7","6011c1d27a056e01646e546a","6011c2b143ac3f003dff1e03","6011c848c98d060607c4958a","6011cf50bda72704c87038b3","6011cf59c412f8059846be53","6011cf6928eb3005a245c925","6011cf7ba648b204adb57aec","6011cfe041e5e005bf97309e","6011d028cd7e160026ae3d20","6011d2314f5963062adcba1a","6011d2ff3e486f0560984f59","6011d3c85f5f920036d01397","6012ece434e66f0046a16db6","6066b7c7d1064a00234c9508","6376b49b2ac94400030a7a28","646791b0a28e6c06f696fb77","6541205377b2190a15527a17","6541205377b2190a15527a18","6541205377b2190a15527a19","6541205377b2190a15527a1a","6509e98612ea3a000bb40411","6509ebf786c93f004507384d","6541205377b2190a15527a1b","6541205377b2190a15527a1c","6541205377b2190a15527a1d","6541205377b2190a15527a1e","653c13fe786fd60065f449ee","6541205377b2190a15527aa1","656f601bf9bd75003e2078b0","6570958208334100eec412b0","65b57fe5064162003155a1a4","65bbca3b7adc2c00383c87d1","65c6898486578e000eecdfd1","65ccf81b9aba0000299887cb","6619430f18098e005e7a5cf5","66196f81a0dfe200360d753c","662aa1074daa7c005c035876","66c6362a025d0c005a28909d","66ec1e913784117131dfdd3e","66edc55f2fc54a005e4a0540","6709930cf504a7006e20c2d6","670fc31b87db74003dbf9546","6711742526344c004d5d6c2b","67117484fd7d140011c3a8d7","671175cdfd7d140011c3a8ec","67117e82522a4b001e7e1678","67192d04d3bf5a006919e7c8","683a02bfab1a560061005eda","683a20b779a72f001e39c578","683a22489d0bb90056ff0cc4","683f22ca4e01cd0044152160","685c4ee41b672d0060f4b4f3","68fbd52691cffd91ac050a3d","68ff7a6c68ccccb9a245b351"],"project":"5d63dabecc03470056f9c570","createdAt":"2023-10-31T15:42:10.972Z","releaseDate":"2019-08-26T13:12:30.117Z","__v":4,"forked_from":"653c13fe786fd60065f449ec","updatedAt":"2026-03-30T17:30:32.383Z","apiRegistries":[{"filename":"ordergroove-restrpc.json","uuid":"jqx21mvmkbf1d9c"},{"filename":"ordergroove-payment-api.json","uuid":"x4ryrmk8xnqpr"},{"filename":"ordergroove-webhooks-api.json","uuid":"x4r1mmmkb8lkth"},{"filename":"ordergroove-cart-management-api.json","uuid":"3s622tlona0k2o"},{"filename":"ordergroove-entitlements-service-api.json","uuid":"37hxpmndgrqr1"},{"filename":"payment_attempt_data_api.yaml","uuid":"c3qf1ommwbmg3y"}],"pdfStatus":"complete","source":"readme"}},"i18n":{"language":"en","translations":{"en":{"common":{"ai":{"aiOpenFailed":"Failed to open SuperHub AI panel.","askAi":"Ask AI","askAiAriaLabel":"Open Ask AI Assistant","mdCopy":"Copy Page","mdOpenFailed":"Failed to open as markdown","mdView":"View as Markdown","mcp":{"appNotFound":"{{app}} does not appear to be installed.","command":"Copy MCP Command","config":"Copy MCP Config","copied":"Copied to clipboard!","cursor":"Connect to Cursor","downloadApp":"Download {{app}}","header":"MCP","vscode":"Connect to VS Code"},"noMdToCopy":"No markdown content available to copy.","openFailed":"Failed to open {{option}}.","settings":{"askAiRequired":"Ask AI must be enabled for your project","description":"Adds a dropdown menu for sharing docs with AI assistants.","disabledInternal":"Disabled for internal docs — set to public to enable","dropdownOptions":"Dropdown Options","preview":"Preview","saveFailed":"Failed to save AI dropdown configuration. Please try again.","title":"AI Dropdown"}},"apiConfig":{"allRequests":"All Requests","allRequestsFilter":"All Requests","apiKeysNotFound":"No API keys found.","apiKeysNotSynced":"API keys are not synced with this developer hub.","apiRequests":"API Requests","authentication":"Authentication","credentials":"Credentials","dayFilter":"Last 24 Hours","emptyStatePrompt":"Make a request to see them here or \u003ca>Try It\u003c/a>!","error":"Error","errorRequestsFilter":"400 & 500","gettingStarted":"Getting Started","logInPrompt":"Log in to see your API keys","monthFilter":"Last 30 Days","moreErrors":"More Errors","moreRequests":"More Requests","myRecentErrors":"My Recent Errors","myRecentRequests":"My Recent Requests","myRequests":"My Requests","myTopEndpoints":"My Top Endpoints","personalizedDocsSetup":"Set up \u003cButton>Personalized Docs\u003c/Button> to show users their API keys.","pickALanguage":"Pick a language","popularEndpoints":"Popular Endpoints","success":"Success","weekFilter":"Past week","yourApiKeys":"Your API Keys"},"attribution":"by {{attribution}}","auth":{"any":"any","apiKey":"API Key","apiKeyPrompt":"Get API Key","apiKeyShow":"Show API Key","apiKeyHide":"Hide API Key","apiKeyToggle":"Toggle API Key","apiInfo":"API Info","authenticate":"Authenticate","authorize":"Authorize","authorizationUrl":"Authorization URL","authorizedScopes":"Authorized scopes for this token","authorizedScopesEmpty":"Token has no authorized scopes","bearer":"Bearer","clearSelection":"Clear Selection","clientId":"Client ID","deselectAll":"Deselect All","credentialMessage":"{{projectName}} accepts {{count}} credential methods. You can use {{option}} of them.","credentialsFor":"Credentials for {{name}}","credentialsForMd":"Credentials for `{{name}}`","either":"eitherLog in to use your API keys","grantType":"Grant Type","info":{"base64":"Your username and password will be combined with a : to form a base64-encoded string: `ENCODED_TOKEN`","basic":"Your username and password are being sent in the [header](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Authorization) of the request.","bearer":"\n  Bearer authentication gives access to the “bearer of the token” and must be sent in the Authorization header. For example:\n  ```bash\n  curl --request POST \\\n       --url https://httpbin.org/anything/bearer\n       --header 'Authorization: Bearer BEARER_TOKEN'\n  ```\n  ","cookie":"Your API Key is being sent as a [cookie](https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies).","header":"Your API Key is sent in the request [header](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers).","jwt":"The bearer token's format is JSON Web Token (JWT). Read more at [JWT.io](https://jwt.io/).","query":"Your API Key is being sent as a query parameter in the [URL](https://developer.mozilla.org/en-US/docs/Web/API/URL)."},"infoTable":{"contact":"Contact","description":"Description","identifier":"Identifier","license":"License","name":"Name","termsOfService":"Terms of Service","title":"Title","summary":"Summary","url":"URL","version":"Version"},"information":"Information","label":"Label","lastUsed":"Last Used","logInPrompt":"Log in to use your API keys","logIn":"Log In","logOut":"Log Out","or":"or","password":"password","passwordHideLabel":"Hide","passwordShowLabel":"Show","reAuthorize":"Re-Authorize","required":"required","requiredScopes":"Required Scopes","requiredScopesMissingMsg_one":"Missing {{count}} required scope","requiredScopesMissingMsg_other":"Missing {{count}} required scopes","scopes":"Scopes","scopeGroupAllRequired":"All {{count}} scopes required","scopesOrRequired":"At least 1 scope group required","scopesMissingCount":"({{count}} missing from this token)","scopesMissingMsg_one":"This operation requires {{count}} additional scope","scopesMissingMsg_other":"This operation requires {{count}} additional scopes","scopesRequiredMsg":"Scopes required for this operation","scopesRequiredNoneMsg":"No scopes required for this operation","selectAll":"Select All","selectCredentials":"Select Credentials","token":"token","tokenDetails":"Token Details","tokenRotationMessage":"We recommend you rotate this token.","tokenUrl":"Token URL","useOwnToken":"Use Your Own Token","username":"username"},"close":"Close","colorScheme":{"dark":"Dark","light":"Light","system":"System","title":"Color Scheme"},"changelog":{"added":"Added","deprecated":"Deprecated","fixed":"Fixed","improved":"Improved","removed":"Removed","title":"Changelog"},"copyToClipboard":{"copiedFull":"Copied to clipboard!","copiedShort":"Copied!","copyFull":"Copy to clipboard","copyShort":"Copy","failed":"Failed to copy to clipboard.","unable":"Unable to copy"},"discussions":{"addCommentLabel":"Add Comment","adminLabel":"Admin","answered":"Answered","askQuestion":"Ask a Question","backToAll":"Back to all","blankBodyError":"Your post body cannot be blank.","blankCommentError":"Your comment cannot be blank.","blankPostError":"Your post cannot be blank.","blankTitleError":"Your post title cannot be blank.","cancelButtonLabel":"Cancel","commentAndMarkAnswered":"Comment and mark answered","commentAndReopen":"Comment and reopen","deleteButtonLabel":"Delete","deleteCommentConfirmation":"Are you sure you want to delete this comment?","deleteCommentPermanentConfirmation":"Are you sure you want to permanently delete this comment?","deleteComentSuccess":"This comment has been deleted","deletePermanentlyButtonLabel":"Permanently Delete","deletePostConfirmation":"Are you sure you want to delete this post?","editButtonLabel":"Edit","editedLabel":"edited","emailInputAriaLabel":"name@email.com","emailInputPlaceholder":"Your Email","errorMessagePrefix":"Error:","faqAddLabel":"Add to FAQ","faqRemoveLabel":"Remove from FAQ","faqsLabel":"FAQs","logInToComment":"\u003cb>Log in\u003c/b> to add a comment.","markAsAnswered":"Mark as answered","markAsUnanswered":"Mark as unanswered","markCommentSpamLabel":"Mark this comment as spam","markPostSpamLabel":"Mark this post as spam","nameAndEmailError":"Please fill out your name and email.","nameInputAriaLabel":"Your name","nameInputPlaceholder":"Full name","permanentlyDeleteLabel":"Permanently delete","questionInputAriaLabel":"New question","recaptchaInvalidError":"Invalid ReCaptcha tokens.","recaptchaRequiredError":"Please complete the reCaptcha verification.","recentLabel":"Recent","saveButtonLabel":"Save","submitButtonLabel":"Post Question","tagButtonLabel":"Tag","tagInputPlaceholder":"Enter tag","titleInputAriaLabel":"Question title","titleInputPlaceholder":"Your question title","unansweredLabel":"Unanswered","voteCountLabel":"{{count}} vote","voteCountLabel_plural":"{{count}} votes"},"emptyState":{"changelog":{"title":"No Changelogs"},"discussion":{"actionLabel":"New Question","description":"Nobody's asked a question yet. Be the first!","title":"No Discussions"},"guide":{"title":"No Guides"},"recipe":{"title":"No Recipes"},"reference":{"title":"No API Endpoints"}},"more":"more…","next":"Next","onlyVisibleToAdmins":"Only visible to ReadMe admins","owlbotChat":{"assistant":"Assistant","clearChat":"Clear chat history","closeChat":"Close chat","emptyMessage":"I’ll help you find answers in the docs","emptyTitle":"Ask AI","failureTitle":"Ask AI","fallbackHeading":"Something went wrong with Ask AI","fallbackMessage":"Please try refreshing the page or contact support if the problem persists.","inputPlaceholder":"Ask a question","sendFailure":"Failed to send message. Please try again.","tryAgain":"Try Again","typingLabel":"Generating","voteFailure":"Failed to record vote. It may take a moment for the message to be saved. Please try again.","aiDisclaimer":"AI can get things wrong, so double check any info or code. You're responsible for verifying results are accurate and fit your needs before taking action. Do not input sensitive information.","voteLabelDown":"Not helpful","voteLabelUp":"Helpful"},"pageNotFound":{"heading":"Page Not Found","metaTitle":"404 Not Found"},"pageThumbs":{"no":"No","placeHolder":"Leave an optional comment…","prompt":"Did this page help you?","submit":"Vote","thankYou":"Thanks for voting!","yes":"Yes"},"poweredBy":"Powered by","recipes":{"inThisRecipe":"In this Recipe","openRecipe":"Open Recipe","step_one":"{{count}} step","step_other":"{{count}} steps"},"reference":{"callback":"Callback","clearExample":"Clear Example","clearResponse":"Clear Response","data":"Data","example":"Example","examplePrompt":"Choose an example","examplePromptOr":"Or choose an example","examples":"Examples","headers":"Headers","invalidJSON":"Invalid JSON","inspectRequest":"Inspect Request","jsonEditorAriaLabel":"Toggle Raw JSON Editor","jsonEditorLabel":"Edit JSON Body","language":"Language","library":"Library","log":"Log","logsLoading":"Retrieving recent requests…","logsPrompt":"Make a request to see history.","logsSeeAllLabel":"See All Requests","logsStatusLabel":"Status","logsThisMonth_one":"{{count}} Request This Month","logsThisMonth_other":"{{count}} Requests This Month","logsTimeLabel":"Time","logsUserAgentLabel":"User Agent","payloadExample":"Payload Example","recentRequests":"Recent Requests","replayRequest":"Replay Request","request":"Request","requestExample":"Request Example","requestExamples":"Request Examples","requestHistoryPrompt":"Log in to see full request history","requestInstructions":"Request instructions","resetBody":"Reset Body","response":"Response","showDescription":"Show Description","hideDescription":"Hide Description","sdkCodeEmpty":"No SDK code available","sdkCodeError":"Error retrieving SDK code. Please try again later.","tryIt":"Try It","tryItPrompt":"Click \u003ccode>Try It!\u003c/code> to start a request and see the response here!","tryItPunctuated":"Try It!"},"search":{"askFailure":"We had an issue responding, please try again later","filtersLabel":"Filters","filtersPlaceholder":"Filter","forMore":"for more","fromTheDocs":"From the Docs","inProject":"in {{project}}","noResults":"No search results for '{{query}}'","placeholder":"Search","pressEnterToAskAi":"Press \u003ckbd>Enter\u003c/kbd> to ask AI","promptEmpty":"Start typing to search…","promptLoading":"Keep typing to search…","searching":"Searching…","thinking":"Thinking"},"sections":{"all":"All","apiLogs":"API Logs","changelog":"Changelog","discussions":"Discussions","guides":"Guides","graphql":"GraphQL","home":"Home","pages":"Pages","recipes":"Recipes","reference":"API Reference"},"tableOfContents":"Table of Contents","time":{"absolute":{"noPrefix":"{{time}}","noPrefixAttributed":"{{time}} by {{attribution}}","postedPrefix":"Posted {{time}}","postedPrefixAttributed":"Posted {{time}} by {{attribution}}","updatedPrefix":"Updated {{time}}","updatedPrefixAttributed":"Updated {{time}} by {{attribution}}"},"justNow":{"noPrefix":"Less than a minute ago","noPrefixAttributed":"Less than a minute ago by {{attribution}}","postedPrefix":"Posted just now","postedPrefixAttributed":"Posted just now by {{attribution}}","updatedPrefix":"Updated just now","updatedPrefixAttributed":"Updated just now by {{attribution}}"},"relative":{"noPrefix":"{{time}}","noPrefixAttributed":"{{time}} by {{attribution}}","postedPrefix":"Posted {{time}}","postedPrefixAttributed":"Posted {{time}} by {{attribution}}","updatedPrefix":"Updated {{time}}","updatedPrefixAttributed":"Updated {{time}} by {{attribution}}"}},"unableToCopy":"Unable to copy","version":{"beta":"Beta","default":"Default","deprecated":"Deprecated","hiddenLabel":"Hidden Version"},"whatsNext":"What’s Next"}}}},"is404":false,"isFramePreview":false,"isStreamingSSR":false,"isDetachedProductionSite":false,"lang":"en","langFull":"Default","reqUrl":"/page/graphql-orders","version":{"_id":"6541205377b2190a15527a9f","version":"2.10.0","version_clean":"2.10.0","codename":"","is_stable":true,"is_beta":false,"is_hidden":false,"is_deprecated":false,"categories":["5d63dabecc03470056f9c575","6541205377b2190a15527a07","5d63de895179b9004cf25083","6541205377b2190a15527a08","6541205377b2190a15527a09","6541205377b2190a15527a0a","6541205377b2190a15527a0b","6541205377b2190a15527a0c","6541205377b2190a15527a0d","6541205377b2190a15527a0e","6541205377b2190a15527a0f","6541205377b2190a15527a10","6541205377b2190a15527a11","6541205377b2190a15527a12","6541205377b2190a15527a13","5d7900c7d202e7003baec4b9","5d790119b3a9600024df0154","5da5e2cbc9b875004c79804f","5dc976352c62b30047202bcf","5dcc503bd6d997002e28a2fc","5ddc07a83604cd004a95db37","6541205377b2190a15527a15","5f74b18f26833a004fb62c9c","6541205377b2190a15527a16","600895cdd4fedc001ea6e230","600896a80742ab004868158f","6011a019ec3e230011f40f46","6011a18d86276d00127aa69c","6011a27603c6b10056bd6681","6011a542e07e9f003a1938ca","6011a6e90ac1c2004008f867","6011b6335d8879006ea33d33","6011b6f8702e6e00397c2568","6011b71d01538900728b57fa","6011b885ec85810065f1e0db","6011b9865b40f800335ea54c","6011bc459f9939002791ee38","6011bf675bb4f3002c1b1225","6011c1876febb20073b944f7","6011c1d27a056e01646e546a","6011c2b143ac3f003dff1e03","6011c848c98d060607c4958a","6011cf50bda72704c87038b3","6011cf59c412f8059846be53","6011cf6928eb3005a245c925","6011cf7ba648b204adb57aec","6011cfe041e5e005bf97309e","6011d028cd7e160026ae3d20","6011d2314f5963062adcba1a","6011d2ff3e486f0560984f59","6011d3c85f5f920036d01397","6012ece434e66f0046a16db6","6066b7c7d1064a00234c9508","6376b49b2ac94400030a7a28","646791b0a28e6c06f696fb77","6541205377b2190a15527a17","6541205377b2190a15527a18","6541205377b2190a15527a19","6541205377b2190a15527a1a","6509e98612ea3a000bb40411","6509ebf786c93f004507384d","6541205377b2190a15527a1b","6541205377b2190a15527a1c","6541205377b2190a15527a1d","6541205377b2190a15527a1e","653c13fe786fd60065f449ee","6541205377b2190a15527aa1","656f601bf9bd75003e2078b0","6570958208334100eec412b0","65b57fe5064162003155a1a4","65bbca3b7adc2c00383c87d1","65c6898486578e000eecdfd1","65ccf81b9aba0000299887cb","6619430f18098e005e7a5cf5","66196f81a0dfe200360d753c","662aa1074daa7c005c035876","66c6362a025d0c005a28909d","66ec1e913784117131dfdd3e","66edc55f2fc54a005e4a0540","6709930cf504a7006e20c2d6","670fc31b87db74003dbf9546","6711742526344c004d5d6c2b","67117484fd7d140011c3a8d7","671175cdfd7d140011c3a8ec","67117e82522a4b001e7e1678","67192d04d3bf5a006919e7c8","683a02bfab1a560061005eda","683a20b779a72f001e39c578","683a22489d0bb90056ff0cc4","683f22ca4e01cd0044152160","685c4ee41b672d0060f4b4f3","68fbd52691cffd91ac050a3d","68ff7a6c68ccccb9a245b351"],"project":"5d63dabecc03470056f9c570","createdAt":"2023-10-31T15:42:10.972Z","releaseDate":"2019-08-26T13:12:30.117Z","__v":4,"forked_from":"653c13fe786fd60065f449ec","updatedAt":"2026-03-30T17:30:32.383Z","apiRegistries":[{"filename":"ordergroove-restrpc.json","uuid":"jqx21mvmkbf1d9c"},{"filename":"ordergroove-payment-api.json","uuid":"x4ryrmk8xnqpr"},{"filename":"ordergroove-webhooks-api.json","uuid":"x4r1mmmkb8lkth"},{"filename":"ordergroove-cart-management-api.json","uuid":"3s622tlona0k2o"},{"filename":"ordergroove-entitlements-service-api.json","uuid":"37hxpmndgrqr1"},{"filename":"payment_attempt_data_api.yaml","uuid":"c3qf1ommwbmg3y"}],"pdfStatus":"complete","source":"readme"},"gitVersion":{"base":"2.9.0","display_name":null,"i18n":{"lang":null,"parsed_version":null},"name":"2.10.0","release_stage":"release","source":"readme","state":"current","updated_at":"2026-05-07T14:14:52.000Z","uri":"/branches/2.10.0","privacy":{"view":"default"}},"versions":{"total":5,"data":[{"base":"2.5.0","display_name":"Subscription Management Interface","i18n":{"lang":null,"parsed_version":null},"name":"2.6.0","release_stage":"beta","source":"readme","state":"current","updated_at":"2025-11-18T16:20:45.383Z","uri":"/branches/2.6.0","privacy":{"view":"public"}},{"base":"2.5.0","display_name":null,"i18n":{"lang":null,"parsed_version":null},"name":"2.8.0","release_stage":"release","source":"readme","state":"current","updated_at":"2025-11-18T16:12:15.888Z","uri":"/branches/2.8.0","privacy":{"view":"public"}},{"base":"2.8.0","display_name":null,"i18n":{"lang":null,"parsed_version":null},"name":"2.9.0","release_stage":"release","source":"readme","state":"current","updated_at":"2025-11-18T16:02:16.248Z","uri":"/branches/2.9.0","privacy":{"view":"public"}},{"base":"2.9.0","display_name":null,"i18n":{"lang":null,"parsed_version":null},"name":"2.10.0","release_stage":"release","source":"readme","state":"current","updated_at":"2026-05-07T14:14:53.304Z","uri":"/branches/2.10.0","privacy":{"view":"default"}},{"base":"2.10.0","display_name":null,"i18n":{"lang":null,"parsed_version":null},"name":"2.10.1-gplplay","release_stage":"release","source":"readme","state":"current","updated_at":"2026-04-13T15:06:34.838Z","uri":"/branches/2.10.1-gplplay","privacy":{"view":"public"}}],"type":"version"}}</script></div><div id="hub-container"><div class="hub-container"><div state-container ng-attr-id="{{state.current().root !== 'docs' &amp;&amp; 'react-app-content-container'}}"><div id="replace-view" ng-non-bindable></div></div></div></div><script>/*<![CDATA[*/window.zEmbed||function(e,t){var n,o,d,i,s,a=[],r=document.createElement("iframe");window.zEmbed=function(){a.push(arguments)},window.zE=window.zE||window.zEmbed,r.src="javascript:false",r.title="",r.role="presentation",(r.frameElement||r).style.cssText="display: none",d=document.getElementsByTagName("script"),d=d[d.length-1],d.parentNode.insertBefore(r,d),i=r.contentWindow,s=i.document;try{o=s}catch(e){n=document.domain,r.src='javascript:var d=document.open();d.domain="'+n+'";void(0);',o=s}o.open()._l=function(){var o=this.createElement("script");n&&(this.domain=n),o.id="js-iframe-async",o.src=e,this.t=+new Date,this.zendeskHost=t,this.zEQueue=a,this.body.appendChild(o)},o.write('<body onload="document._l();">'),o.close()}("https://assets.zendesk.com/embeddable_framework/main.js","ordergroove.zendesk.com");
/*]]>*/
</script><script>!function(){var analytics=window.analytics=window.analytics||[];if(!analytics.initialize)if(analytics.invoked)window.console&&console.error&&console.error("Segment snippet included twice.");else{analytics.invoked=!0;analytics.methods=["trackSubmit","trackClick","trackLink","trackForm","pageview","identify","group","track","ready","alias","page","once","off","on"];analytics.factory=function(t){return function(){var e=Array.prototype.slice.call(arguments);e.unshift(t);analytics.push(e);return analytics}};for(var t=0;t<analytics.methods.length;t++){var e=analytics.methods[t];analytics[e]=analytics.factory(e)}analytics.load=function(t){var e=document.createElement("script");e.type="text/javascript";e.async=!0;e.src=("https:"===document.location.protocol?"https://":"http://")+ "cdn.segment.com" +"/analytics.js/v1/"+t+"/analytics.min.js";var n=document.getElementsByTagName("script")[0];n.parentNode.insertBefore(e,n)};analytics.SNIPPET_VERSION="3.0.1";
analytics.load("dQkKQTUclHQ60x3aeiUZkNJllzEvEFg5");
}}();
</script><script>var is_hub = true;
var is_hub2 = true;
var is_hub_edit = true;
</script><div id="ssr-end"><script id="__LOADABLE_REQUIRED_CHUNKS__" type="application/json">[2852,4863,7154,7783,1456,3307,3760,2447,1924,2759,6123,6328,6146,9503,5492,8804,6479,8850,8735,8788,3678,5798]</script><script id="__LOADABLE_REQUIRED_CHUNKS___ext" type="application/json">{"namedChunks":["routes-SuperHub","Containers-EndUserContainer","Header","routes-SuperHub-Routes","CustomPage","ConnectMetadata","RDMD","Footer"]}</script>
<script async data-chunk="main" src="https://cdn.readme.io/public/hub/web/main.cbffc40ba4cf9166e585.js"></script>
<script async data-chunk="routes-SuperHub" src="https://cdn.readme.io/public/hub/web/routes-SuperHub.0bc764dff71f3d0333ac.js"></script>
<script async data-chunk="Containers-EndUserContainer" src="https://cdn.readme.io/public/hub/web/Containers-EndUserContainer.01e921597f816edd7e87.js"></script>
<script async data-chunk="Header" src="https://cdn.readme.io/public/hub/web/7154.1c8f05e443c98afc7a0f.js"></script>
<script async data-chunk="Header" src="https://cdn.readme.io/public/hub/web/7783.e3a96d2d4e2c0cf1ee32.js"></script>
<script async data-chunk="Header" src="https://cdn.readme.io/public/hub/web/Header.a4a4a6e16e106134b124.js"></script>
<script async data-chunk="routes-SuperHub-Routes" src="https://cdn.readme.io/public/hub/web/routes-SuperHub-Routes.f72c8d8d47efc314c741.js"></script>
<script async data-chunk="CustomPage" src="https://cdn.readme.io/public/hub/web/3760.5a51af39357427d3c55f.js"></script>
<script async data-chunk="CustomPage" src="https://cdn.readme.io/public/hub/web/CustomPage.5116ddec2abe493c18cd.js"></script>
<script async data-chunk="ConnectMetadata" src="https://cdn.readme.io/public/hub/web/ConnectMetadata.7acf3bac8b27bf379d05.js"></script>
<script async data-chunk="RDMD" src="https://cdn.readme.io/public/hub/web/2759.fcb8db7f411e07138d64.js"></script>
<script async data-chunk="RDMD" src="https://cdn.readme.io/public/hub/web/6123.3cf2d759650e72709b6b.js"></script>
<script async data-chunk="RDMD" src="https://cdn.readme.io/public/hub/web/6328.cf13ec042f3090c9cff5.js"></script>
<script async data-chunk="RDMD" src="https://cdn.readme.io/public/hub/web/6146.cb8f37a2ef0ab72d4bf7.js"></script>
<script async data-chunk="RDMD" src="https://cdn.readme.io/public/hub/web/9503.36898a7a11ea5cc38308.js"></script>
<script async data-chunk="RDMD" src="https://cdn.readme.io/public/hub/web/5492.ff4a6bd49595b926b88b.js"></script>
<script async data-chunk="RDMD" src="https://cdn.readme.io/public/hub/web/8804.be101e35a551c64842f5.js"></script>
<script async data-chunk="RDMD" src="https://cdn.readme.io/public/hub/web/6479.e42542b9e97772ee967e.js"></script>
<script async data-chunk="RDMD" src="https://cdn.readme.io/public/hub/web/8850.e583937352ffa8a54ec1.js"></script>
<script async data-chunk="RDMD" src="https://cdn.readme.io/public/hub/web/8735.929987ccecda48e3c68e.js"></script>
<script async data-chunk="RDMD" src="https://cdn.readme.io/public/hub/web/8788.3c071cd2380b8d501415.js"></script>
<script async data-chunk="RDMD" src="https://cdn.readme.io/public/hub/web/RDMD.b4750a9d7f03279fe61a.js"></script>
<script async data-chunk="Footer" src="https://cdn.readme.io/public/hub/web/Footer.9f298ad202e3e5a56dd5.js"></script></div><script>(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','//www.google-analytics.com/analytics.js','ga');
</script><script>ga('create', 'UA-167013636-1', 'auto', {'name': 'custom'});
$(window).on('pageLoad', function(e, state){
  ga('custom.send', 'pageview', window.location.pathname);
});
</script><script>$(window).on('pageLoad', function(e, state){
  analytics.page(window.location.pathname, state.meta.title, {
    "context": {
      "plugin": {
        "name": "readme_io",
        "version": "1.0.0"
      }
    }
  })
});
</script><script>
    // workaround to make the nav links open in a new tab
		setTimeout(() => {
        document.querySelector("#ssr-main > div > div.SuperHub2RNxzk6HzHiJ > div > div.ContentWithOwlbot-content2X1XexaN8Lf2 > header > div.Header-bottom2eLKOFXMEmh5.Header-bottom_compact.rm-Header-bottom.Header-bottom_withOwlbot3wuKp8NLXCqs > div > nav > a:nth-child(6)").setAttribute("target", "_blank");
        document.querySelector("#ssr-main > div > div.SuperHub2RNxzk6HzHiJ > div > div.ContentWithOwlbot-content2X1XexaN8Lf2 > header > div.Header-bottom2eLKOFXMEmh5.Header-bottom_compact.rm-Header-bottom.Header-bottom_withOwlbot3wuKp8NLXCqs > div > nav > a:nth-child(7)").setAttribute("target", "_blank");
    }, 3000);
 </script><script id="hub-me" type="application/json" data-json="{&quot;loggedIn&quot;:false,&quot;search&quot;:{&quot;app&quot;:&quot;T28YKFATPY&quot;,&quot;token&quot;:&quot;ZTA4NzdmYTRkODc1N2JjZTM4NzgxZDQ0OWVlYzFkOTdlNjM4ODdjZTY5YWMxMDA4ZjliM2ZiZDg4MTNhODVmY3RhZ0ZpbHRlcnM9KHByb2plY3Q6NWQ2M2RhYmVjYzAzNDcwMDU2ZjljNTcwKSwodmVyc2lvbjpub25lLHZlcnNpb246NjU0MTIwNTM3N2IyMTkwYTE1NTI3YTlmKSwoaGlkZGVuOm5vbmUsaGlkZGVuOmZhbHNlKSwoaW5kZXg6Q3VzdG9tUGFnZSxpbmRleDpQYWdlKQ==&quot;,&quot;filters&quot;:&quot;tagFilters=(project:5d63dabecc03470056f9c570),(version:none,version:6541205377b2190a15527a9f),(hidden:none,hidden:false),(index:CustomPage,index:Page)&quot;,&quot;metaData&quot;:[{&quot;modules&quot;:{&quot;logs&quot;:false,&quot;suggested_edits&quot;:false,&quot;discuss&quot;:false,&quot;changelog&quot;:false,&quot;reference&quot;:true,&quot;examples&quot;:true,&quot;docs&quot;:true,&quot;landing&quot;:false,&quot;custompages&quot;:false,&quot;tutorials&quot;:false,&quot;graphql&quot;:false},&quot;id&quot;:&quot;5d63dabecc03470056f9c570&quot;,&quot;name&quot;:&quot;Ordergroove API Reference&quot;,&quot;subdomain&quot;:&quot;og-restrpc&quot;,&quot;subpath&quot;:&quot;&quot;,&quot;nav_names&quot;:{&quot;discuss&quot;:&quot;&quot;,&quot;changelog&quot;:&quot;&quot;,&quot;reference&quot;:&quot;&quot;,&quot;docs&quot;:&quot;&quot;,&quot;tutorials&quot;:&quot;&quot;,&quot;recipes&quot;:&quot;&quot;}}]}}"></script><script id="readme-data-baseUrl" type="application/json"></script></body></html>