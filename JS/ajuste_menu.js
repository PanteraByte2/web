window.addEventListener('resize', function(){
    var menuHeight = this.document.querySelector('header').offsetHeight;
    this.document.querySelector('main').style.paddingTop = menuHeight + 'px';
})

window.dispatchEvent(new Event('resize'));