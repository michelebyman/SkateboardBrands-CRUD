<template>
    <div id="app">
        <h1 class="header"><span class="header-span">Skateboard | </span>Brands</h1>
        <form action>
            <table id="skateBrands">
                <tr>
                    <th>Brand</th>
                    <th>Description</th>
                    <th>Favorite</th>
                </tr>
                <tr :class="editing ? 'tableBrands' : 'hover'" v-for="brand in brands" :key="brand.id">
                    <td v-if="editing === brand.id">
                        <input type="text" v-model="brand.name" />
                    </td>
                    <td v-else>{{brand.name}}</td>

                    <td v-if="editing === brand.id">
                        <input type="text" v-model="brand.description" />
                    </td>
                    <td v-else>{{brand.description}}</td>

                    <td v-if="editing === brand.id">
                        <input type="text" v-model="brand.favorite" />
                    </td>
                    <td v-else>{{!!brand.favorite}}</td>

                    <td v-if="editing === brand.id">
                        <button
                            class="btn edit"
                            @click.prevent="cancelEdit(brand)"
                        >Cancel edit</button>
                        <button class="btn" @click.prevent="updateBrand(brand)">Save</button>
                    </td>
                    <td v-else>
                        <button class="btn del" @click="removeBrand(brand.id)">Delete</button>
                        <button class="btn" @click.prevent="editMode(brand)">Edit</button>
                    </td>
                </tr>
            </table>
        </form>

        <button class="btn addNewBrand" @click="showModal = !showModal">Add New Brand</button>

        <div id="modal" v-show="showModal">
            <BrandCreate 
                @closeModal="updateShowModal" 
                @newBrand="updateBrandsList($event)">
             </BrandCreate>
        </div>


        
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
           
            brands: [],
            showModal: false,
            editing: null,
            name: "",
            description: "",
            favorite: "",
            savedBrand: null
        };
    },
    mounted() {
        this.getBrands();
    },
    methods: {
        updateBrandsList(newBrand) {
            this.brands.push(newBrand);
            this.showModal = false;
        },
        updateShowModal(e) {
            this.showModal = e;
        },
        getBrands() {
            Axios.get("/brands", {
                headers: {
                    accept: "application/json"
                }
            })
                .then(res => {
                    this.brands = res.data;
                })
                .catch(err => {
                    console.error(err);
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
            })
                .then(res => {
                    console.log(res.data);
                                this.brands = this.brands.filter(brand => brand.id !== id);

                })
                .catch(err => {
                    console.error(err);
                });
        },

        editMode(brand) {
            //receives the brand saves it incase we whant to cancel
            this.savedBrand = Object.assign({}, brand);
            this.editing = brand.id;
        },
        cancelEdit(brand) {
            // takes the saved object  overwrite it with the saved object
            Object.assign(brand, this.savedBrand);
            this.editing = null;
        },

        updateBrand(brand) {
            const meta = document.querySelector('meta[name="csrf-token"]');

            Axios("/brands/" + brand.id, {
                method: "PUT",
                data: {
                    name: brand.name,
                    description: brand.description,
                    favorite: brand.favorite
                },
                headers: {
                    "content-type": "application/json",
                    "X-CSRF-Token": meta.content,
                    "X-Requested-With": "XMLHttpRequest"
                }
            })
                .then(res => {
                //     const updatedBrand = this.brands.find(
                //         b => b.id === res.data.id
                //     );
                //     updatedBrand.name = res.data.name;
                //     updatedBrand.description = res.data.description;
                //     updatedBrand.favorite = res.data.favorite;
                    this.editing = false;
                })
                .catch(err => {
                    console.error(err);
                });
        }
    }
};
</script>


