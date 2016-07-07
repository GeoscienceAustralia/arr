   var routing = {
   	init: function() {

   	}
   }
   
   	var Content = {
         currentLink: null,
         currentBook: null,

   		init: function() {

   		},
         get: function(url, menuClick) {

            var link, parts, book, chapter;

            if (!url) return;
            parts = url.split("#");

            link = parts[0];
            if (!link) return;

            var section = parts[1];
            
            // Get Book
            var bookArr = link.match("bk(.*)");
            if (bookArr && bookArr.length > 1) 
               book = bookArr[1].substring(0, 2);
            

            // Get Chapter
            var chapterArr = link.match("ch(.*)");
               if (chapterArr && chapterArr.length > 1) 
                  chapter = chapterArr[1].substring(0, 2);

            // Check if just jumping to id
            if (link == Content.currentLink) {

               if (section) {
                  window.location.hash = section;
               }

               return;
            }

            // Check if different book
            if (!menuClick && book && Content.currentBook && book != Content.currentBook) {

               $('.menu__link').removeClass('menu__link--current');
               // Update top level menu

               $subMenuEl = $('.menu__link').filter('[data-top="true"]').filter('[data-bk="'+ book +'"]');
               menu.o._back();
               
               // Open sub menu
               //menu.o._openSubMenu($subMenuEl, $subMenuEl.attr('data-pos'), $subMenuEl.text());
            }

            // Check if different chapter
            if (!menuClick && chapter && Content.currentChapter && chapter != Content.currentChapter) {

               // Update sub menu
               $('.menu__link').removeClass('menu__link--current');
               $('.menu__link').filter('[data-sub="true"]').filter('[data-bk="'+ book +'"]').filter('[data-ch="'+ chapter +'"]').addClass('menu__link--current');

            }  

            Content.currentBook = book;
            Content.currentLink = link;
            Content.currentChapter = chapter;

            $.get ("./content/"+ url, function (data)
            {     
               Content.update(data, section);
               Content.bind();

            }, 'xml');

         }, 
         update: function(content, section) {

            //closeMenu();  classie.remove(menuEl, 'menu--open');

            var gridWrapper = document.querySelector('.content');

            gridWrapper.innerHTML = '';

            classie.add(gridWrapper, 'content--loading');
            
            setTimeout(function() {

               classie.remove(gridWrapper, 'content--loading');
               
               var body = $(content).find('body');
               $('.content').html(body);


               if (section) {
                   window.location.hash = section;
               }

               MathJax.Hub.Queue(["Typeset",MathJax.Hub]);
            }, 700);

         }, 
         find: function(ev, data) {

            // Dont reaload the page
            ev.preventDefault();

            // Parameters passed from MLMenu

            var menuItem = ev.target;
            var url = $(menuItem).attr('href');
            if ($(menuItem).hasClass('menu__link')) 
                  var menuClick = true;
               else 
                  var menuClick = false;

            Content.get(url, menuClick);
         }, 
         bind: function() {

            var self = this;

            // Bind click events

            $(document).off('click').on("click","a",function(e){
               

               if ($(this).hasClass('menu__link')) 
                  var menuClick = true;
               else 
                  var menuClick = false;

               e.preventDefault();

               $this = $(this);

               var url = $this.attr('href');
               Content.get(url, menuClick);

            });
         }

   	}


   	var menu = {
         o: null,
   		init: function() {

            var self = this;

            menuEl = document.getElementById('ml-menu'),
               mlmenu = new MLMenu(menuEl, {
                  // breadcrumbsCtrl : true, // show breadcrumbs
                  // initialBreadcrumb : 'all', // initial breadcrumb text
                  backCtrl : false, // show back button
                  // itemsDelayInterval : 60, // delay between each menu item sliding animation
                  onItemClick: Content.find // callback: item that doesn´t have a submenu gets clicked - onItemClick([event], [inner HTML of the clicked item])
               });

               self.o = mlmenu;

   		},
   		update: function() {

   		},
   	}

      $(document).ready(function() {


         menu.init();

         // Init Menu


         // mobile menu toggle
         var openMenuCtrl = document.querySelector('.action--open'),
            closeMenuCtrl = document.querySelector('.action--close');

         openMenuCtrl.addEventListener('click', openMenu);
         closeMenuCtrl.addEventListener('click', closeMenu);

         function openMenu() {
            classie.add(menuEl, 'menu--open');
         }

         function closeMenu() {
            classie.remove(menuEl, 'menu--open');
         }

      });