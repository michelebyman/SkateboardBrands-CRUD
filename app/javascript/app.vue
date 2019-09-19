<template>
  <div id="app">
    <h1 class="header">
      <span class="header-span">Skateboard |</span>
      {{t.description.title}}
    </h1>
    <form action>
      <table id="skateBrands">
        <tr>
          <th></th>
          <th>{{t.table.title.brand}}</th>
          <th>{{t.table.title.description}}</th>
          <th>{{t.table.title.favorite}}</th>
        </tr>

        <tr :class="editing ? 'tableBrands' : 'hover'" v-for="brand in brands" :key="brand.id">
          <td>
            <img class="brand_image" :src="brand.avatar_image" alt />
          </td>

          <td v-if="editing === brand.id">
            <input class="edit-inputfield" type="text" v-model="brand.name" />
            <div v-if="errors.name">
              <p>Can't be blank</p>
            </div>
          </td>
          <td v-else>{{brand.name}}</td>

          <td v-if="editing === brand.id">
            <input class="edit-inputfield" type="text" v-model="brand.description" />
            <div v-if="errors.description">
              <p>Can't be blank</p>
            </div>
          </td>
          <td v-else>{{brand.description}}</td>

          <td v-if="editing === brand.id">
            <input class="edit-inputfield" type="text" v-model="brand.favorite" />
          </td>
          <td v-else>{{!!brand.favorite}}</td>

          <td v-if="editing === brand.id">
            <button class="btn edit" @click.prevent="cancelEdit(brand)">{{t.button.cancelEdit}}</button>
            <button class="btn" @click.prevent="updateBrand(brand)">{{t.button.save}}</button>
          </td>

          <td v-else>
            <button class="btn del" @click.prevent="removeBrand(brand.id)">{{t.button.delete}}</button>
            <button class="btn" @click.prevent="editMode(brand)">{{t.button.edit}}</button>
          </td>
        </tr>
      </table>
    </form>

    <button class="btn addNewBrand" @click="showModal = !showModal">{{t.button.addNewBrand}}</button>

    <div id="modal" v-show="showModal">
      <BrandCreate @closeModal="updateShowModal" @newBrand="updateBrandsList($event)"></BrandCreate>
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
      description: null,
      favorite: "",
      savedBrand: null,
      //injected through a script file and gives us all access to translations
      t: I18n,

      errors: {
        name: "",
        description: ""
      }
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
      //token to access the database
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
          console.error(err.response.data);

          this.errors.name = err.response.data.name;
          this.errors.description = err.response.data.description;
        });
    }
  }
};
</script>


