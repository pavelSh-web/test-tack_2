<gallery class="gallery animate__fadeInUp">
    <div class="container">
        <div class="gallery-inner">
            <div class="gallery-item gallery-item_{size} added" style="background: {color}" each={gallery}>
                <img class="gallery-image b-lazy" data-src={src} data-color="{color}" alt="">
            </div>
        </div>
    </div>
    <div class="loading" if = {showLoading}></div>
    <script>

        //Стартовый шаблон основной сетки
        let resultObj = {
            gallery: []
        };
        

        const tagElem = this.root;
        //url запроса
        let clientId = 'fVktfCz87cJUOPqt1n8TE2LVqWNRpCNIupj9frxQsiY';
        const query = ['drone view', 'sea', 'summer', 'nature', 'sky', 'mountain', 'travel', 'tourism', 'lake'];
        let url = 'https://api.unsplash.com/search/photos/?client_id=' +
        clientId + '&query='; 

        //Добавление класса, отменяющего 'position: fixed' у элемента .photo-head
        if (screen.height <= 550) {
            document.querySelector('.photo-head').classList.add('unfixed');
        }

        //Функция изменений при повороте тач-устройства
        const doOnOrientationChange = () => {
            if (window.orientation == -90 || window.orientation == 90) {
                if (screen.height <= 550) {
                    document.querySelector('.photo-head').classList.add('unfixed');
                } else {
                    document.querySelector('.photo-head').classList.remove('unfixed');
                }
            } else {
                document.querySelector('.photo-head').classList.remove('unfixed');
            }
        }
        window.addEventListener('orientationchange', doOnOrientationChange); 


        //Функция запрашивает фотографии и формирует их в сетку
        const getPhoto = (url) => {
            

            //Шаблон сетки
            let gridArr = [
                [{ size: "xs" }, { size: "s" }, { size: "m" }],
                [{ size: "m" }, { size: "l" }, { size: "xs" }],
                [{ size: "l" }, { size: "xs" }, { size: "s" }],
            ];

            //Рандомный url
            url += query[Math.floor(Math.random() * query.length)];
            
            //Запускаем лоадер
            this.showLoading = true;
            riot.update();
            
            fetch(url)  
                .then((response) => {
                    
                    if (response.status !== 200) {  
                        console.log('Looks like there was a problem. Status Code: ' +  
                        response.status);  
                        return;  
                    }

                    response.json().then((data) => {
                        //Счетчик для фотографий
                        let count = 0;                   

                        for ( let i = 0; i < 3; i++) {
                            //Рандомный индекс для gridArr
                            const randomI = Math.floor(Math.random() * gridArr.length);
                            //Заполнение каждого элемента столбца
                            for( let j = 0; j < 3; j++ ) {
                                gridArr[randomI][j].src = data.results[count].urls.regular;
                                gridArr[randomI][j].color = data.results[count].color;
                                count++
                            }
                            resultObj.gallery = resultObj.gallery.concat(gridArr[randomI]);
                            console.log(this.gallery);
                            gridArr.splice(randomI, 1);
                        }
                        this.gallery = resultObj.gallery;
                        //Отключаем лоадер
                        this.showLoading = false;
                        riot.update();
                        
                        window.addEventListener('scroll', listenerScroll);
                        //Запускаем ленивую загрузку
                        new Blazy({
                            offset: -200
                        });
                    });  
                })
                .catch((err) => {  
                    console.log('Fetch Error :-S', err);  
                });
        }
        getPhoto(url);

        //Функция добавляет верхний отступ у gallery
        const addMargin = () => {
            function elementSize(selector) {
                const element = document.querySelector(selector);
                return element.clientHeight;
            }
            document.querySelector('gallery').style.marginTop = elementSize('.photo-head') + 'px';
        }
        addMargin();
        window.addEventListener('resize', () => addMargin())

        //Прослушивание скролла и запрос новых фотографий за 10px до конца страницы
        const listenerScroll = () => {
            const clientHeight = document.documentElement.clientHeight ? document.documentElement.clientHeight : document.body.clientHeight;
            const documentHeight = document.documentElement.scrollHeight ? document.documentElement.scrollHeight : document.body.scrollHeight;
            const scrollTop = window.pageYOffset ? window.pageYOffset : (document.documentElement.scrollTop ? document.documentElement.scrollTop : document.body.scrollTop);

            if((documentHeight - clientHeight) <= scrollTop + 200) {
                window.removeEventListener('scroll', listenerScroll);
                getPhoto(url);
            }
        }

        //Функция скрытия модального окна
        function removeModal() {
            this.remove();
            document.body.style.overflow = 'scroll';
            document.body.style.paddingRight = '0';
            document.querySelector('.photo').style.opacity = '1';
        }
        
        //Фунуция выполняется при клике на фото
        const onClickPhoto = (e) => {
            //Создаем модальное окно
            const target = e.target;
            if (target.classList.contains('gallery-image')) {
                const src = (target.dataset.src || target.src);
                const result = `<img class="photo-modal__image animate__fadeInDown_m" src="${src}" alt=""> `
                const newElem = document.createElement("div");
                newElem.classList.add('photo-modal');
                newElem.style.backgroundColor = `${target.dataset.color}4D`;

                const wrap = document.body.appendChild(newElem);
                wrap.innerHTML = result;
                
                //Фиксируем скролл и убираем дерганье body
                document.body.style.paddingRight = `${calcScroll()}px`;
                document.body.style.overflow = 'hidden';
                document.querySelector('.photo').style.opacity = '0';
            }
            
            //Удаление модального окна при клике на него
            document.querySelector('.photo-modal').addEventListener('click', removeModal);
        }

        //Запуск слушателя на клик
        let updateCount = 0;
        this.on("update", () => {
            if (updateCount === 0) {
                console.log('add listener')
                document.querySelector('.gallery-inner').addEventListener('click', onClickPhoto);
            }
            updateCount++;
        });


        //Расчет ширины скролл-бара
        const calcScroll = () => {
            let div = document.createElement('div');
            div.style.width = '50px';
            div.style.height = '50px';
            div.style.overflowY = 'scroll';
            div.style.visibility = 'hidden';
            document.body.appendChild(div);
            let scrollWidth = div.offsetWidth - div.clientWidth;
            div.remove();

            return scrollWidth;
        }        

        //Отслеживание конца страницы и отправка нового запроса
        window.addEventListener('scroll', listenerScroll);

    </script>
</gallery>
