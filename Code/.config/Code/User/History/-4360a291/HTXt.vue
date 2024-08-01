<script setup lang="ts">
import { computed } from 'vue';
import { Nullable } from 'primevue/ts-helpers';
import InputGroup from 'primevue/inputgroup';

interface Props {
    label: string;
    col: number;
    errorMessage?: string | null;
    readonly: boolean | undefined;
    disabled: boolean | undefined;
}

const value = defineModel<Nullable<number>>();

const props = defineProps<Props>();

const colClass = computed(() => `md:col-${props.col}`);
</script>

<template>
    <div class="col-12 flex align-items-center gap-2" :class="colClass">
        <label for="input" class="font-medium text-900 text-2xl min-w-max col-4">{{ label }}</label>
        <div class="flex flex-column col-6">
            <slot />
        </div>
    </div>
</template>

<style scoped lang="scss"></style>
