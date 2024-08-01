<script setup lang="ts">
import { computed } from 'vue';
import { Nullable } from 'primevue/ts-helpers';
import InputGroup from 'primevue/inputgroup';

interface Props {
    label: string;
    col: number;
}

const props = defineProps<Props>();

const colClass = computed(() => `md:col-${props.col}`);
</script>

<template>
    <div class="col-12 flex align-items-center gap-2" :class="colClass">
        <label class="font-medium text-900 text-2xl w-full">{{ label }}</label>
        <div class="grid">
            <slot />
        </div>
    </div>
</template>

<style scoped lang="scss"></style>
