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
    <div class="col-12 flex align-items-center gap-2" :class="colClass">
        <label for="input" class="font-medium text-900 text-2xl min-w-max col-6">{{ label }}</label>
        <div class="flex flex-column">
            <InputGroup>
                <slot v-if="$slots.input" name="input" />
                <InputNumber
                    v-else
                    v-model="value"
                    id="input"
                    type="text"
                    :minFractionDigits="0"
                    :maxFractionDigits="8"
                    :class="{ 'p-invalid': errorMessage }"
                    :readonly="readonly"
                    :disabled="disabled"
                />
                <slot name="input-group" />
            </InputGroup>
            <label class="p-error mt-1">{{ errorMessage }}</label>
        </div>
    </div>
</template>

<style scoped lang="scss"></style>
