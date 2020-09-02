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
            let gridArr = [
                [{ size: "xs" }, { size: "s" }, { size: "l" }],
                [{ size: "s" }, { size: "l" }, { size: "xs" }],
                [{ size: "l" }, { size: "xs" }, { size: "s" }],
            ];
            url += query[Math.floor(Math.random() * query.length)];
            
            
            tagElem.classList.add('loading');
            fetch(url)  
                .then((response) => {
                    
                    if (response.status !== 200) {  
                        console.log('Looks like there was a problem. Status Code: ' +  
                        response.status);  
                        return;  
                    }
                    // Examine the text in the response  
                    response.json().then((data) => {
                        let count = 0;
                        resultObj.gallery.forEach(gridCol => {
                            const randomI = Math.floor(Math.random() * gridArr.length)
                            const fillGrid = gridArr[randomI];
                            gridArr.splice(randomI, 1);
                            for( let j = 0; j < 3; j++ ) {
                                fillGrid[j].src = data.results[count].urls.regular;
                                fillGrid[j].color = data.results[count].color;
                                count++
                            }
                            fillGrid.forEach((item) => gridCol.push(item));
                        });
                        riot.update();
                        tagElem.classList.remove('loading');
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

        window.addEventListener('scroll',() => {
            const clientHeight = document.documentElement.clientHeight ? document.documentElement.clientHeight : document.body.clientHeight;
            const documentHeight = document.documentElement.scrollHeight ? document.documentElement.scrollHeight : document.body.scrollHeight;
            const scrollTop = window.pageYOffset ? window.pageYOffset : (document.documentElement.scrollTop ? document.documentElement.scrollTop : document.body.scrollTop);

            if((documentHeight - clientHeight) <= scrollTop) {
                getPhoto(url);
            }
        }) 
                            

        
        
       

        
        
        //this.gallery = $.getJSON('photo.json', data => data);
    </script>
</gallery>
