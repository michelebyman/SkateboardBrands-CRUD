<template>
        <div>
              <input
              v-model="brand"
               type="text" placeholder="Skateboard Brand..."
               >
              <input 
              v-model="description"
              type="text" placeholder="Description..."
              >
<span>Favorite: {{ favorite }}</span>
              <select v-model="favorite">

  <option disabled value="">Please select one</option>
  <option>Yes</option>
  <option>No</option>
</select>

<button @click="postBrand">Send to data base</button>

             
        </div>
</template>

<script>
import Axios from 'axios'
export default {
        data() {
                return {
                        brand:'',
                        description: '',
                        favorite: ''
                }
        }, 

methods: {
        postBrand() {
                  const meta = document.querySelector('meta[name="csrf-token"]');
                Axios('/brands', {
                        method: "POST",
                        data: {
                                name: this.brand,
                                description: this.description,
                                favorite: true

                                // fix boolean
                        },

                      headers: {
                    "content-type": "application/json",
                    "X-CSRF-Token": meta.content,
                    "X-Requested-With": "XMLHttpRequest"
                }
                }).then((res)=> {
                        console.log(res);
                        
                }) 
        }
},
}
</script>




               