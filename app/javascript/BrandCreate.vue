<template>
    <div class="modalWrapper">
       <div :class="{error: validation.hasError('brand')}">

      <input type="text"  :placeholder="t.modal.newBrand" v-model="brand"/>
      
      <div class="message">{{ validation.firstError('brand') }}</div>
    </div>
       <div :class="{error: validation.hasError('description')}">

      <input type="text"  :placeholder="t.modal.description" v-model="description"/>
      
      <div class="message">{{ validation.firstError('description') }}</div>
    </div>
        
        <div class="favorite-wrapper">
            <span>{{t.modal.favorite}}</span>
            <input class="checkbox" v-model="favorite" type="checkbox" />
        </div>
      
                <button  :disabled="hasErrors" class="btn-send" @click.prevent="postBrand">{{t.button.sendToDataBase}}</button>
    
      
        <button class="btn-close" @click="$emit('closeModal', close)">{{t.button.close}}</button>
     
    </div>
</template>

<script>
 import SimpleVueValidation from 'simple-vue-validator';
  const Validator = SimpleVueValidation.Validator;

import Axios from "axios";
export default {
    data() {
        return {
            brand: "",
            description: "",
            favorite: false,
            close: false,
            newBrand: {},
            hasErrors: true,
            t: window.I18n,
        };
    },
    mounted() {
            this.$validate();
    },
    validators: {
      brand: (value)=> {
        return Validator.value(value).required().lengthBetween(1,15)
     
      },
      description: function (value) {
        return Validator.value(value).required().lengthBetween(2,25);
      },
    },

    watch: {    
            'validation.errors': function(val) {
                    if (val.length == 0) {
                            this.hasErrors = false
                    } else {
                            this.hasErrors = true
                    }
            }
    },

    methods: {
        sendBrand() {
            this.$emit("newBrand", this.newBrand);
        },

        postBrand() {
            const meta = document.querySelector('meta[name="csrf-token"]');
            Axios("/brands", {
                method: "POST",
                data: {
                    name: this.brand,
                    description: this.description,
                    favorite: this.favorite
                },
                headers: {
                    "content-type": "application/json",
                    "X-CSRF-Token": meta.content,
                    "X-Requested-With": "XMLHttpRequest"
                }
            })
                .then(res => {

                        console.log(res.data.id);
                    this.newBrand = res.data;
                    this.sendBrand();
                    this.brand = "";
                    this.description = "";
                    this.favorite = false;
                })
                .catch(err => {
                        console.log(err.response.data);
                });
        }
    }
};
</script>




               