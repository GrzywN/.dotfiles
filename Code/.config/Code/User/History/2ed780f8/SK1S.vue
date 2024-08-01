<script setup lang="ts">
import { computed, ref } from 'vue';
import { MaterialResource } from '@/Resources/Material.resource';
import { IsolatorResource } from '@/Resources/Isolator.resource';
import { WindowResource } from '@/Resources/Window.resource';
import { DoorResource } from '@/Resources/Door.resource';
import { AutoCompleteCompleteEvent } from 'primevue/autocomplete';
import { RoofTypeResource } from '@/Resources/RoofType.resource';

type Items =
    | Array<MaterialResource>
    | Array<IsolatorResource>
    | Array<WindowResource>
    | Array<DoorResource>
    | Array<RoofTypeResource>;

interface Props {
    label: string;
    col: number;
    errorMessage?: string | null;
    items: Items;
    disabled: boolean | undefined;
}

const value = defineModel();

const filteredItems = ref<Items>([]);

const search = (event: AutoCompleteCompleteEvent) => {
    setTimeout(() => {
        if (!event.query.trim().length) {
            filteredItems.value = [...props.items];
        } else {
            filteredItems.value = props.items.filter((item) => {
                return item.name.toLowerCase().indexOf(event.query.toLowerCase()) >= 0;
            });
        }
    }, 250);
};

const props = defineProps<Props>();

const colClass = computed(() => `md:col-${props.col}`);
</script>

<template>
    <div class="flex flex-column field mb-4 col-12" :class="colClass">
        <label for="input" class="font-medium text-900"> {{ label }} </label>
        <AutoComplete
            v-model="value"
            dropdown
            :suggestions="filteredItems"
            option-label="name"
            @complete="search"
            :disabled="disabled"
        >
            <template #option="slotProps"> {{ slotProps.option.name }} ({{ slotProps.option.value }}) </template>
        </AutoComplete>
        <label v-if="errorMessage" class="p-error mt-1">{{ errorMessage }}</label>
    </div>
</template>

<style scoped lang="scss"></style>
