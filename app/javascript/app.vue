<template>
    <div id="app">
        <h1>{{ message }}</h1>

        <table class="tableWrapper">
            <tr>
                <th>Brand</th>
                <th>Description</th>
                <th>Favorite</th>
            </tr>
            <tr v-for="brand in brands" :key="brand.id">
                <td>{{brand.name}}</td>
                <td>{{brand.description}}</td>
                <td>{{!!brand.favorite}}</td>
                <button class="btn btnDelete" @click="removeBrand(brand.id)">Delete</button>
                <button>Edit</button>
            </tr>
        </table>

        <button @click="showModal = !showModal">Add New Brand</button>
        <BrandCreate v-show="showModal"></BrandCreate>
    </div>
</template>

<script>
import Axios from "axios";
import BrandCreate from "./BrandCreate";

export default {
        components: {
                BrandCreate
        },
    data: function() {
        return {
            message: "Skateboard Brands",
            brands: [],
            showModal: false,
        };
    },
    mounted() {
        this.getBrands();
    },
    methods: {
        getBrands() {
            Axios.get("/brands", {
                headers: {
                    accept: "application/json"
                }
            }).then(res => {
                this.brands = res.data;
            });
        },

        removeBrand(id) {
            const meta = document.querySelector('meta[name="csrf-token"]');
            Axios.delete("/brands/" + id, {
                headers: {
                    method: "DELETE",
                    "content-type": "application/json",
                    "X-CSRF-Token": meta.content,
                    "X-Requested-With": "XMLHttpRequest"
                }
            });
        }
    }
};
</script>


