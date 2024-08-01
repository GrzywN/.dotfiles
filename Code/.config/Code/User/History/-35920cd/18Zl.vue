<script setup lang="ts">
import { computed } from 'vue';

interface Props {
    label: string;
    col: number;
    errorMessage?: string | null;
    readonly: boolean | undefined;
    disabled: boolean | undefined;
}

const value = defineModel<boolean>();

const props = defineProps<Props>();

const colClass = computed(() => `col-${props.col}`);
</script>

<template>
    <div :class="colClass">
        <div class="mb-4 flex flex-wrap align-items-center">
            <Checkbox
                v-model="value"
                name="checkbox"
                value="val"
                class="mr-2"
                :binary="true"
                :readonly="readonly"
                :disabled="disabled"
            />
            <label for="checkbox" class="text-900 font-medium mr-2">
                {{ label }}
            </label>
        </div>
    </div>
</template>

<style scoped lang="scss"></style>
