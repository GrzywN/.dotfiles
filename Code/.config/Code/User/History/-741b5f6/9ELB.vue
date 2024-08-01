<script setup lang="ts">
import { computed } from 'vue';
import { Nullable } from 'primevue/ts-helpers';
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
    <div class="field col-12" :class="colClass">
        <label for="input" class="font-medium text-900 min-w-max"> {{ label }} </label>
        <InputNumber
            v-model="value"
            id="input"
            type="text"
            :minFractionDigits="0"
            :maxFractionDigits="8"
            class="w-full"
            :class="{ 'p-invalid': errorMessage }"
            :placeholder="label"
            :readonly="readonly"
            :disabled="disabled"
        />
        <label class="p-error mt-1">{{ errorMessage }}</label>
    </div>
</template>

<style scoped lang="scss"></style>
