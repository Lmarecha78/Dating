<div class="right animated fadeInRight">
    <h1 class="pink2 italic underline">{lang 'Be on the best place to meet people!'}</h1>
    <div class="center">
        <a href="{{ $design->url('user','main','login') }}" class="btn btn-primary btn-lg"><strong>{lang 'Login'}</strong></a>
    </div>
    {{ JoinForm::step1(290) }}

    <div class="counter center">{{ $userDesign->counterUsers() }}</div>
</div>

<div class="left">
  <div class="folio_block">
    <h1 class="pink2 italic underline">{slogan}</h1>

    <div class="splash_slideshow">
      <div class="window">
        <div class="img_reel">
          {* For PHP 5.5+, keep just only the following *} {* {for $i in [1,2,3,4,5]} *}
          {{ $num = [1,2,3,4,5] }}
          {for $i in $num}
            <a href="{url_root}"><img src="{url_tpl_img}slideshow/{i}.jpg" alt="{lang 'Social Dating Web App'}" /></a>
          {/for}
        </div>
      </div>
      <div class="paging">
        <a href="#" rel="1">1</a>
        <a href="#" rel="2">2</a>
        <a href="#" rel="3">3</a>
        <a href="#" rel="4">4</a>
        <a href="#" rel="5">5</a>
      </div>
    </div>
  </div>

  <div class="block_txt">
    <h2>{lang 'Meet people in %0% with %site_name%!', $design->geoIp(false)}</h2>
    {promo_text}
  </div>

  <div class="carousel">{{ $userDesignModel->carouselProfiles() }}</div>
</div>
