<gallery class="gallery animate__fadeInUp">
    <div class="container">
        <div class="gallery-inner">
            <div class="gallery-column" each={column in gallery}>
                <div class="gallery-item gallery-item_{size}" style="background: {color}" each={column}>
                    <img class="b-lazy" data-src={src} alt="">
                </div>
            </div>
        </div>
    </div>
    <script>
        const resultObj = {
            gallery: [[],[],[]]
        }

        this.gallery = resultObj.gallery;
        const tagElem = this.root;

        let clientId = 'fVktfCz87cJUOPqt1n8TE2LVqWNRpCNIupj9frxQsiY';
        const query = ['drone view', 'sea', 'summer', 'nature', 'mountain', 'travel', 'tourism', 'lake'];
        let url = 'https://api.unsplash.com/search/photos/?client_id=' +
        clientId + '&query='; 

        const getPhoto = (url) => {
            //Шаблон сетки
            let gridArr = [
                [{ size: "xs" }, { size: "s" }, { size: "l" }],
                [{ size: "s" }, { size: "l" }, { size: "xs" }],
                [{ size: "l" }, { size: "xs" }, { size: "s" }],
            ];
            //Рандомный url
            url += query[Math.floor(Math.random() * query.length)];
            
            //Запускаем лоадер
            tagElem.classList.add('loading');

            fetch(url)  
                .then((response) => {
                    
                    if (response.status !== 200) {  
                        console.log('Looks like there was a problem. Status Code: ' +  
                        response.status);  
                        return;  
                    }

                    response.json().then((data) => {
                        let count = 0;
                        resultObj.gallery.forEach(gridCol => {
                            //Рандомный столбец сетки
                            const randomI = Math.floor(Math.random() * gridArr.length)
                            //Массив для предварительного заполнения
                            const fillGrid = gridArr[randomI];
                            gridArr.splice(randomI, 1);
                            //Заполнение каждого элемента столбца
                            for( let j = 0; j < 3; j++ ) {
                                fillGrid[j].src = data.results[count].urls.regular;
                                fillGrid[j].color = data.results[count].color;
                                count++
                            }
                            //Пушим созданную колонку
                            fillGrid.forEach((item) => gridCol.push(item));
                        });
                        riot.update();
                        //Отключаем лоадер
                        tagElem.classList.remove('loading');
                        //Запускаем ленивую загрузку
                        var blazy = new Blazy({
                            offset: -200
                        });
                    });  
                })
                .catch(function(err) {  
                    console.log('Fetch Error :-S', err);  
                });
        }

        getPhoto(url);

        //Добаляем верхний отступ у gallery
        function elementSize(selector) {
            const element = document.querySelector(selector);
            return element.clientHeight;
        }
        document.querySelector('gallery').style.marginTop = elementSize('.photo-head') + 'px';


        //Отслеживание конца страницы
        window.addEventListener('scroll',() => {
            const clientHeight = document.documentElement.clientHeight ? document.documentElement.clientHeight : document.body.clientHeight;
            const documentHeight = document.documentElement.scrollHeight ? document.documentElement.scrollHeight : document.body.scrollHeight;
            const scrollTop = window.pageYOffset ? window.pageYOffset : (document.documentElement.scrollTop ? document.documentElement.scrollTop : document.body.scrollTop);

            if((documentHeight - clientHeight) <= scrollTop) {
                getPhoto(url);
            }
        });
    </script>
</gallery>
