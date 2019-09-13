<template>
    <div class="modalWrapper">
        <input v-model="brand" type="text" placeholder="Skateboard Brand..." />
        <input v-model="description" type="text" placeholder="Description..." />
        <div class="favorite-wrapper">
            <span>Favorite:</span>
            <input class="checkbox" v-model="favorite" type="checkbox" />
        </div>
        <button class="btn-send" @click="postBrand">Send to Database</button>
        <button class="btn-close" @click="$emit('closeModal', close)">Close</button>
    </div>
</template>

<script>
import Axios from "axios";
export default {
    data() {
        return {
            brand: "",
            description: "",
            favorite: "",
            close: false,
            newBrand: {}
        };
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
                    this.newBrand = res.data;
                    this.sendBrand();
                    this.brand = "";
                    this.description = "";
                    this.favorite = "";
                })
                .catch(err => {
                    console.error(err);
                });
        }
    }
};
</script>




               